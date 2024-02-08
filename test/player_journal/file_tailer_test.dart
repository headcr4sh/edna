import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show Directory, File, FileMode, IOSink;

import 'package:path/path.dart' as path;
import 'package:file/memory.dart' show FileSystemStyle, MemoryFileSystem;
import 'package:test/test.dart' show group, setUp, tearDown, test, expect;
import 'package:edna/player_journal/file_tailer.dart';

late Directory tmpDir;

/// Test data
List<String> movies = [
  'Star Wars Episode IV - A New Hope',
  'Star Wars Episode V - The Empire Strikes Back',
  'Star Wars Episode VI - Return of the Jedi',
  'Star Wars Episode VII - The Force Awakens'
];

typedef AsyncCallback = Future<void> Function();

class FileContentsTester {
  final File _file;
  final List<String> _lines;
  final AsyncCallback? _onClose;
  IOSink? _ioSink;
  int _linesWritten = 0;
  FileContentsTester(final File file, final List<String> lines, {final AsyncCallback? onClose})
      : _file = file,
        _lines = lines,
        _onClose = onClose {
      _ioSink = _file.openWrite(mode: FileMode.writeOnlyAppend);
  }

  IOSink get ioSink {
    return _ioSink!;
  }

  bool get hasNext {
    return _linesWritten < _lines.length;
  }

  Future<void> writeNext() async {
    if (hasNext) {
      ioSink.writeln(_lines[_linesWritten]);
      await ioSink.flush();
      _linesWritten++;
    } else {
      throw StateError('Cannot write data past last line.');
    }
  }

  Future<void> writeAll() async {

    while(hasNext) {
      await writeNext();
    }

    await ioSink.flush();
    await ioSink.close();
    if (_onClose != null) {
      await _onClose!();
    }

  }

}

void main() {
  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('dart-file-tailer_');
  });
  tearDown(() async {
    if (await tmpDir.exists()) {
      await tmpDir.delete(recursive: true);
    }
  });
  group('FileTailer', () {
    final fs = MemoryFileSystem(style: FileSystemStyle.posix);
    test('Default constructor / factory', () {
      final file = fs.file('/tmp/does-not-exist.txt');
      final tailer = FileTailer(file);
      expect(tailer.file, file);
    });
    test('tail()', () async {

      final file = await File(path.join(tmpDir.path, 'movies.txt')).create();
      final tailer = FileTailer(file);
      final tester = FileContentsTester(file, movies, onClose: () async => await tailer.cancel(pos: await file.length()));

      var idx = 0;

      await Future.wait([
        tester.writeAll(),
        tailer.stream().transform(utf8.decoder).transform(LineSplitter()).forEach((line) async {
          expect(line, movies[idx]);
          idx++;
        })
      ]);

      expect(movies.length, idx);
    });
  });
}
