import 'dart:async' show Stream, StreamController;
import 'dart:convert' show utf8, LineSplitter;
import 'dart:io' show Directory, File, sleep;
import 'dart:math' show Random;

import 'package:edna/player_journal/status.dart' show Status, UpdatableStatus;
import 'package:path/path.dart' as path;

import './journal_path.dart' show journalPath;
import './file_tailer.dart' show FileTailer;
import './player_journal_event_record.dart';
import './player_journal_event_record_codec.dart' show PlayerJournalEventRecordDecoder;

/// Regular expression to match the format of Journal files as we know them.
RegExp journalFilePattern = RegExp(r'^Journal\.(?<serial01>\d+)\.(?<serial02>\d+)\.log$');

abstract class PlayerJournalEventRecordSource {
  final UpdatableStatus _status;
  Status get status => _status;

  Stream<PlayerJournalEventRecord> stream();

  PlayerJournalEventRecordSource():
      _status = UpdatableStatus();

  /// Creates a event source that emits random player journal events.
  /// Only for test or demonstration purposes.
  factory PlayerJournalEventRecordSource.dummy() => DummyPlayerJournalEventRecordSource();
  factory PlayerJournalEventRecordSource.local({final String? path}) {

    return LocalPlayerJournalEventRecordSource(Directory(path ?? journalPath()));
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

  Future<File> currentJournalFile({final bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentJournalFile = null;
    }

    if (_currentJournalFile != null) {
      return _currentJournalFile!;
    }

    File? journalFile;
    while (journalFile == null) {
      journalFile = await _playerJournalPath.list().fold<File?>(null, (previous, element) {
        final filename = path.basename(element.path);
        final match = journalFilePattern.firstMatch(filename);
        if (match == null) {
          return previous;
        }
        if (previous == null) {
          if (element is File) {
            return element;
          }
        } else {
          final prevMatch = journalFilePattern.firstMatch(path.basename(previous.path));
          if (match.namedGroup('serial01')!.compareTo(prevMatch!.namedGroup('serial01')!) >= 0 &&
              match.namedGroup('serial02')!.compareTo(prevMatch.namedGroup('serial02')!) >= 0) {
            return element is File ? element : null;
          }
        }
        return null;
      });
      // Wait a little while before retrying...
      if (journalFile == null) {
        sleep(Duration(seconds: 5));
      }
    }
    _currentJournalFile = File.fromUri(journalFile.uri);
    return _currentJournalFile!;
  }

  Stream<PlayerJournalEventRecord> _stream(final File journalFile) {
    final ctrl = StreamController<PlayerJournalEventRecord>();
    final tailer = FileTailer(journalFile, bufferSize: 8192);
    tailer
        .stream()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .transform(PlayerJournalEventRecordDecoder())
        .forEach((event) async {
          ctrl.add(event);
          if (event.event == PlayerJournalShutdownEventRecord.type) {
            _currentJournalFile = null;
            await ctrl.close();
            await tailer.cancel();
          }
        }).asStream();
    return ctrl.stream;
  }

  @override
  Stream<PlayerJournalEventRecord> stream() async* {
    yield* _stream(await currentJournalFile());
  }
}
