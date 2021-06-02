import 'dart:async' show Stream, StreamController;
import 'dart:convert' show utf8, LineSplitter;
import 'dart:io' show Directory, File, FileSystemEntity, Platform;

import 'package:path/path.dart' as path;

import './file_tailer.dart' show FileTailer;
import './player_journal_event_record.dart';
import './player_journal_event_record_codec.dart' show PlayerJournalEventRecordDecoder;

RegExp journalFilePattern = RegExp(r'^Journal\.(?<serial01>\d+)\.(?<serial02>\d+)\.log$');

abstract class PlayerJournalEventRecordSource {
  Stream<PlayerJournalEventRecord> stream();

  /// Creates a event source that emits random player journal events.
  /// Only for test or demonstration purposes.
  factory PlayerJournalEventRecordSource.dummy() => DummyPlayerJournalEventRecordSource();
  factory PlayerJournalEventRecordSource.local({final String? path}) {
    return path == null ? LocalPlayerJournalEventRecordSource.fromDefaultPath() : LocalPlayerJournalEventRecordSource(playerJournalPath: path);
  }
}

class DummyPlayerJournalEventRecordSource implements PlayerJournalEventRecordSource {
  @override
  Stream<PlayerJournalEventRecord> stream() async* {
    // TODO yield random events with random delay between each other.
    throw UnimplementedError();
  }
}

class LocalPlayerJournalEventRecordSource implements PlayerJournalEventRecordSource {
  static String defaultPath() {
    final String edJournalPath;
    final ednaJournalDirEnv = Platform.environment['EDNA_JOURNAL_DIR'];
    final edJournalDirEnv = Platform.environment['ED_JOURNAL_DIR'];
    if (ednaJournalDirEnv != null) {
      edJournalPath = ednaJournalDirEnv;
    } else if (edJournalDirEnv != null) {
      edJournalPath = edJournalDirEnv;
    } else if (Platform.isWindows) {
      final userHomePath = Platform.environment['USERPROFILE'];
      if (userHomePath == null || userHomePath.isEmpty) {
        throw Exception('Variable %USERPROFILE% has not been set');
      }
      edJournalPath = path.join(userHomePath, 'Saved Games', 'Frontier Developments', 'Elite Dangerous');
    } else if (Platform.isLinux) {
      final userHomePath = Platform.environment['HOME'];
      if (userHomePath == null || userHomePath.isEmpty) {
        throw Exception('Variable \$HOME has not been set');
      }
      edJournalPath = path.joinAll([userHomePath, '.local', 'share', 'Steam', 'steamapps', 'compatdata', '359320', 'pfx', 'drive_c', 'users', 'steamuser' ,'Saved Games', 'Frontier Developments', 'Elite Dangerous']);
    } else {
      throw Exception('Player journal default path cannot be determined');
    }
    return edJournalPath;
  }

  final String _playerJournalPath;
  String? _currentJournalFile;

  LocalPlayerJournalEventRecordSource({required String playerJournalPath}) : _playerJournalPath = playerJournalPath {
    assert(_playerJournalPath.isNotEmpty);
    assert(Directory(_playerJournalPath).existsSync());
  }

  LocalPlayerJournalEventRecordSource.fromDefaultPath() : _playerJournalPath = defaultPath();

  Future<String?> currentJournalFile({bool refresh = false}) async {
    if (_currentJournalFile != null && !refresh) {
      return _currentJournalFile!;
    }
    var journalFile = await Directory(_playerJournalPath).list().fold<FileSystemEntity?>(null, (previous, element) {
      final filename = path.basename(element.path);
      final match = journalFilePattern.firstMatch(filename);
      if (match == null) {
        return previous;
      }
      if (previous == null) {
        return element;
      }
      final prevMatch = journalFilePattern.firstMatch(path.basename(previous.path));
      if (match.namedGroup('serial01')!.compareTo(prevMatch!.namedGroup('serial01')!) >= 0 && match.namedGroup('serial02')!.compareTo(prevMatch.namedGroup('serial02')!) >= 0) {
        return element;
      }
      return null;
    });
    _currentJournalFile = journalFile?.path;
    return _currentJournalFile;
  }

  Stream<PlayerJournalEventRecord> _stream(File journalFile) {
    var ctrl = StreamController<PlayerJournalEventRecord>();
    var tailer = FileTailer(journalFile, bufferSize: 8192);
    tailer
        .stream()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .transform(PlayerJournalEventRecordDecoder())
        .forEach((event) async {
          ctrl.add(event);
          if (event.event == PlayerJournalShutdownEventRecord.type) {
            await ctrl.close();
            await tailer.cancel();
          }
        });
    return ctrl.stream;
  }

  @override
  Stream<PlayerJournalEventRecord> stream() async* {
    var journalFilePath = await currentJournalFile();
    // TODO Handle cases where journal file does not exist (yet)
    yield* _stream(File(journalFilePath!));
  }
}
