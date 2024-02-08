import 'dart:typed_data' show Uint8List;
import 'dart:io' show File, FileSystemEvent, FileMode, FileSystemModifyEvent, RandomAccessFile;
import 'dart:async' show Completer;
import 'package:async/async.dart' show StreamGroup;

const _DEFAULT_BUFFER_SIZE = 8192;
const _DEFAULT_READ_TIMEOUT = Duration(milliseconds: 100);

/// Facility to tail a file's contents.
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
  factory FileTailer(final File file, {final int bufferSize = _DEFAULT_BUFFER_SIZE, final Duration readTimeout = _DEFAULT_READ_TIMEOUT}) {
    return _FileTailer(file, bufferSize: bufferSize, readTimeout: readTimeout);
  }
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

  _FileTailer(final File file, {required final int bufferSize, required final Duration readTimeout})
      : _file = file,
        _buf = Uint8List(bufferSize),
        _readTimeout = readTimeout,
        _pos = 0;

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
    _pos = await fileHandle.position();

    // Wait for modify events and read more bytes from file
    await for (final event in events) {
      if (_cancelled) {
        await fileHandle.close();
        return;
      }
      switch (event.type) {
        case FileSystemEvent.modify:
          yield* _read(fileHandle);
          break;
        case FileSystemEvent.delete:
          await cancel();
          break;
        default:
          // All other events should be ignored for now.
          break;
      }
      if (_cancelled) {
        await fileHandle.close();
        return;
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
        // Let's check if we have been cancelled.
        continue;
      }
      _pos += bytesRead;
      yield _buf.sublist(0, bytesRead);
    }
    _done.complete();
  }
}
