import 'dart:async' show Stream, StreamController;
import 'dart:convert' show utf8, LineSplitter;
import 'dart:io' show Directory, File, sleep;
import 'dart:math' show Random;

import './file_tailer.dart' show FileTailer;
import './player_journal.dart' show PlayerJournal;
import './player_journal_event_record.dart';
import './player_journal_event_record_codec.dart' show PlayerJournalEventRecordDecoder;
import 'journal_log_file.dart' as journal_log_file;

abstract class PlayerJournalEventRecordSource {

  Stream<PlayerJournalEventRecord> stream();

  PlayerJournalEventRecordSource();

  /// Creates an event source that emits random player journal events.
  /// Only for test or demonstration purposes.
  factory PlayerJournalEventRecordSource.dummy() => DummyPlayerJournalEventRecordSource();

  /// Creates an event source that reads player journal events from local files.
  factory PlayerJournalEventRecordSource.local({final Directory? path}) {
    return LocalPlayerJournalEventRecordSource(path ?? PlayerJournal.localJournalPath());
  }
}

class DummyPlayerJournalEventRecordSource extends PlayerJournalEventRecordSource {

  final Random _random;

  DummyPlayerJournalEventRecordSource():
        _random = Random(1337);

  @override
  Stream<PlayerJournalEventRecord> stream() async* {
    sleep(Duration(milliseconds: _random.nextInt(200)));
    yield PlayerJournalFileheaderEventRecord(
        timestamp: DateTime.now(),
        part: 1,
        language: 'English\\UK',
        gameVersion: 'Fleet Carriers Update - Patch 11',
        build: 'r254828/r0 '
    );
    while (true) {
      sleep(Duration(milliseconds: _random.nextInt(200)));
      // TODO yield random events with random delay between each other.
      throw UnimplementedError();
    }
  }
}

class LocalPlayerJournalEventRecordSource extends PlayerJournalEventRecordSource {

  final Directory _playerJournalPath;
  File? _currentJournalFile;

  LocalPlayerJournalEventRecordSource(final Directory journalPath)
      : _playerJournalPath = journalPath {
    assert(_playerJournalPath.existsSync());
  }

  Future<File> currentJournalLogFile({final bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentJournalFile = null;
    }

    if (_currentJournalFile != null) {
      return _currentJournalFile!;
    }
    while (_currentJournalFile == null) {
      _currentJournalFile = await journal_log_file.currentJournalLogFile(playerJournalPath: _playerJournalPath);
      // Wait a little while before retrying...
      if (_currentJournalFile == null) {
        sleep(Duration(seconds: 5));
      }
    }
    return _currentJournalFile!;

  }

  Future<File> nextJournalLogFile(final int part) async {
    if (_currentJournalFile == null) {
      return currentJournalLogFile();
    }
    final lastPath = _currentJournalFile!.path;
    _currentJournalFile = null;
    while (_currentJournalFile == null) {
      final possibleNextFile = await journal_log_file.nextJournalLogFile(playerJournalPath: _playerJournalPath, currentJournalFile: _currentJournalFile!);
      if (possibleNextFile?.path != lastPath) {
        _currentJournalFile = possibleNextFile;
      }
      // Wait a little while before retrying...
      if (_currentJournalFile == null) {
        sleep(Duration(seconds: 5));
      }
    }
    return _currentJournalFile!;
  }

  Stream<PlayerJournalEventRecord> _stream(final File journalFile) {
    final ctrl = StreamController<PlayerJournalEventRecord>();
    final tailer = FileTailer.fromStart(journalFile, follow: true, bufferSize: 8192);
    tailer
        .stream()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .transform(PlayerJournalEventRecordDecoder())
        .forEach((record) async {
          ctrl.add(record);
          switch (record.event) {
            case PlayerJournalContinuedEventRecord.type:
              nextJournalLogFile((record as PlayerJournalContinuedEventRecord).part);
              await ctrl.close();
              tailer.cancel();
              break;
          }
          if (record.event == PlayerJournalShutdownEventRecord.type) {
            _currentJournalFile = null;
            await ctrl.close();
            tailer.cancel();
          }
        }).asStream();
    return ctrl.stream;
  }

  @override
  Stream<PlayerJournalEventRecord> stream() async* {
    yield* _stream(await currentJournalLogFile());
  }
}
