import 'dart:async' show Completer;
import 'dart:io'
    show
        File,
        FileMode,
        FileSystemEvent,
        FileSystemModifyEvent,
        RandomAccessFile;
import 'dart:math' show max;
import 'dart:typed_data' show Uint8List;

import 'package:async/async.dart' show StreamGroup;

const _defaultBufferSize = 8192;
const _defaultReadTimeout = Duration(milliseconds: 100);

final _posRegex = RegExp(r'^(?<pfx>\+?)(?<num>\d+)$');

enum _PositionMode {
  bytes,
  lines;

  @override
  String toString() => name;
}

int _calculatePos(final File file, {final String? bytes, String? lines}) {
  // Fall back to default position if nothing else has been specified.
  if (bytes == null && lines == null) {
    return _calculatePos(file, lines: '10');
  }

  if (bytes != null && lines != null) {
    throw ArgumentError(
        'Either "bytes" or "lines" must be specified, not both.');
  }

  final posMode = bytes != null ? _PositionMode.bytes : _PositionMode.lines;
  final posDesc = _posRegex.firstMatch((bytes ?? lines)!);
  if (posDesc == null) {
    throw ArgumentError('Argument $posMode must match format `[+]NUM`');
  }

  final posDir = posDesc.namedGroup('pfx') == '+' ? '+' : '-';
  final posNum = int.parse(posDesc.namedGroup('num')!);

  final fileLength = file.lengthSync();
  final int pos;
  switch (posMode) {
    case _PositionMode.bytes:
      if (posDir == '+') {
        pos = posNum > fileLength ? fileLength : posNum;
      } else {
        pos = max(fileLength - posNum, 0);
      }
      break;
    case _PositionMode.lines:
      throw ArgumentError('Not yet implemented.');
    default:
      throw UnimplementedError(
          'posMode "${posMode.toString()}" not supported.');
  }
  return pos;
}

/// Facility to tail the contents of a file.
abstract class FileTailer {
  File get file;

  /// Starts to read from the file pointed at by this tailer.
  /// The caller of this function is responsible for cancelling the
  /// read request by calling the appropriate method if no more data
  /// shall be received.
  Stream<List<int>> stream();

  /// Cancels the tailing once the given position at [pos] has been reached.
  /// Pass `-1` as [pos] to cancel immediately.
  Future<void> cancel({int pos = -1});

  // Creates a new tailer, that can be used to stream the contents of a file.
  factory FileTailer(final File file,
          {final bool? follow,
          final String? lines,
          final String? bytes,
          final int? bufferSize,
          final Duration? readTimeout}) =>
      _FileTailer(file,
          follow: follow ?? false,
          bufferSize: bufferSize ?? _defaultBufferSize,
          readTimeout: readTimeout ?? _defaultReadTimeout,
          pos: _calculatePos(file, lines: lines, bytes: bytes));

  // Creates a new tailer that ready everything from the start of the given
  // file.
  factory FileTailer.fromStart(final File file,
          {final bool? follow,
          final int? bufferSize,
          final Duration? readTimeout}) =>
      FileTailer(file,
          follow: follow,
          bufferSize: bufferSize,
          readTimeout: readTimeout,
          bytes: '+0');
}

// Starts tailing the contents of a file.
(Stream<List<int>>, Future<void> Function({int pos})) tailFile(final File file,
    {final bool follow = false,
    final String? lines,
    final String? bytes,
    final int bufferSize = _defaultBufferSize,
    final Duration readTimeout = _defaultReadTimeout}) {
  final tailer = FileTailer(file,
      follow: follow,
      lines: lines,
      bytes: bytes,
      bufferSize: bufferSize,
      readTimeout: readTimeout);
  return (tailer.stream(), tailer.cancel);
}

/// Default implementation of the file tailer interface.
class _FileTailer implements FileTailer {
  final File _file;
  final Uint8List _buf;
  final Duration _readTimeout;

  final Completer<void> _done = Completer();

  int _pos;
  bool _cancelled = false;
  int _cancelledPos = -1;
  final bool _follow;

  _FileTailer(final File file,
      {required final bool follow,
      required final int bufferSize,
      required final Duration readTimeout,
      required final int pos})
      : _file = file,
        _buf = Uint8List(bufferSize),
        _readTimeout = readTimeout,
        _follow = follow,
        _pos = pos;

  @override
  File get file => _file;

  @override
  Stream<List<int>> stream() async* {
    final events = StreamGroup.merge([
      // Initial event, because the file might already contain data which
      // we want to consume before something gets appended.
      Stream.value(FileSystemModifyEvent(_file.path, false, true)),
      // Modification events
      _file.watch(events: FileSystemEvent.all)
    ]);

    final fileHandle = await _file.open(mode: FileMode.read);
    if (_pos == 0) {
      _pos = await fileHandle.position();
    } else {
      await fileHandle.setPosition(_pos);
    }

    // Wait for modify events and read more bytes from file
    await for (final event in events) {
      if (_cancelled) {
        await fileHandle.close();
        break;
      }
      switch (event.type) {
        case FileSystemEvent.modify:
          yield* _read(fileHandle);
        case FileSystemEvent.delete:
          await cancel();
        default:
          // All other events should be ignored for now.
          break;
      }
      if (_cancelled || !_follow) {
        await fileHandle.close();
        break;
      }
    }
  }

  @override
  Future<void> cancel({final int pos = -1}) async {
    _cancelled = true;
    _cancelledPos = pos;

    // Wait until reading has truly come to an end.
    return _done.future;
  }

  Stream<Uint8List> _read(final RandomAccessFile fileHandle) async* {
    while (!(_cancelled && _pos >= _cancelledPos)) {
      final bytesRead = await fileHandle.readInto(_buf).timeout(_readTimeout);
      if (bytesRead == 0) {
        if (_follow) {
          // Let's check if we have been cancelled.
          continue;
        }
        break;
      }
      _pos += bytesRead;
      yield _buf.sublist(0, bytesRead);
    }
    _done.complete();
  }
}
