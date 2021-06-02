import 'dart:typed_data' show Uint8List;
import 'dart:io' show File, FileSystemEvent, FileMode, FileSystemModifyEvent, RandomAccessFile;

abstract class FileTailer {
  File get file;
  Stream<List<int>> stream();
  Future<void> cancel({int pos = -1});
  factory FileTailer(final File file, {final int bufferSize = 8192}) {
    return _FileTailer(file, bufferSize: bufferSize);
  }
}

/// Default implementation of the file tailer interface.
class _FileTailer implements FileTailer {
  bool _cancelled = false;
  int _cancelledPos = -1;

  final File _file;

  final Uint8List _buf;
  int _pos;
  int _len;

  _FileTailer(final File file, {required final int bufferSize})
      : _file = file,
        _buf = Uint8List(bufferSize),
        _len = 0,
        _pos = 0;

  @override
  File get file {
    return _file;
  }

  @override
  Stream<List<int>> stream() async* {

    // Begin watching for events before anything else to avoid nasty
    // race conditions.
    final events = _file.watch(events: FileSystemEvent.all);

    final fileHandle = await _file.open(mode: FileMode.read);
    _pos = await fileHandle.position();
    _len = await _file.length();
    // Step 1: read whole file
    yield* _read(fileHandle);
    // Step 2: wait for modify events and read more bytes from file
    await for (final event in events) {
      if (_cancelled) {
        return;
      }
      switch (event.type) {
        case FileSystemEvent.modify:
          if ((event as FileSystemModifyEvent).contentChanged) {
            _len = await (_file.length());
            yield* _read(fileHandle);
          }
          break;
        default:
          // All other events should be ignored for now.
          break;
      }
      if (_cancelled) {
        return;
      }
    }
  }

  @override
  Future<void> cancel({int pos = -1}) async {
    _cancelled = true;
    _cancelledPos = pos;
  }

  Stream<Uint8List> _read(RandomAccessFile fileHandle) async* {
    while (_pos < _len) {
      if (_cancelled && _pos >= _cancelledPos) return;
      final bytesRead = await fileHandle.readInto(_buf);
      _pos += bytesRead;
      yield _buf.sublist(0, bytesRead);
    }
    if (_cancelled && _pos >= _cancelledPos) return;
  }
}
