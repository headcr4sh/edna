import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show Directory, File, FileMode, IOSink;

import 'package:path/path.dart' as path;
import 'package:file/memory.dart' show FileSystemStyle, MemoryFileSystem;
import 'package:test/test.dart' show group, setUp, tearDown, test, expect;
import 'package:edna/player_journal/file_tailer.dart';

Directory? tmpDir;

List<String> movies = [
  'Star Wars Episode IV - A New Hope',
  'Star Wars Episode V - The Empire Strikes Back',
  'Star Wars Episode VI - Return of the Jedi',
];

typedef AsyncCallback = Future<void> Function();

class FileContentsTester {
  final File _file;
  final AsyncCallback? _onClose;
  IOSink? _ioSink;
  int _idx = 0;
  FileContentsTester(final File file, {final bool writeFirst = false, final AsyncCallback? onClose })
      : _file = file,
        _onClose = onClose {
    if (writeFirst) {
      _ioSink = _file.openWrite(mode: FileMode.writeOnlyAppend);
      writeNext();
    }
  }

  IOSink get ioSink {
    return _ioSink!;
  }

  bool get hasNext {
    return _idx < movies.length;
  }

  Future<void> writeNext() async {
    if (hasNext) {
      ioSink.writeln(movies[_idx]);
      await ioSink.flush();
      _idx++;
    }
    if (!hasNext) {
      await ioSink.flush();
      await ioSink.close();
      if (_onClose != null) {
        await _onClose!();
      }
    }
  }
}

void main() {
  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('edna-file-tailer_');
  });
  tearDown(() async {
    if (await tmpDir!.exists()) {
      await tmpDir!.delete(recursive: true);
    }
  });
  group('FileTailer', () {
    final fs = MemoryFileSystem(style: FileSystemStyle.posix);
    test('Default constructor / factory', () {
      final file = fs.file('/tmp/does-not-exist.txt');
      final tailer = FileTailer(file);
      expect(tailer.file, file);
    });
    test('.tail()', () async {
      final moviesList = await File(path.join(tmpDir!.path, 'movies.txt')).create();
      final tailer = FileTailer(moviesList, bufferSize: 8);
      final tester = FileContentsTester(moviesList, writeFirst: true, onClose: () async {
        await tailer.cancel(pos: await moviesList.length());
      });

      var idx = 0;
      await tailer.stream().transform(utf8.decoder).transform(LineSplitter()).forEach((line) async {
        expect(line, movies[idx]);
        idx++;
        await tester.writeNext();
      });
    });
  });
}
