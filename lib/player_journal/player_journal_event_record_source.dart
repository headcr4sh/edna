import 'dart:async' show Stream, StreamController;
import 'dart:io' show Directory, File, sleep, WebSocket;
import 'dart:math' show Random;
import 'dart:convert' show jsonDecode, utf8, LineSplitter;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

import './file_tailer.dart' show FileTailer;
import './player_journal.dart' show PlayerJournal;
import './event_record/player_journal_event_record.dart';
import './player_journal_event_record_codec.dart'
    show PlayerJournalEventRecordDecoder;
import 'journal_log_file.dart' as journal_log_file;

abstract class PlayerJournalEventRecordSource {
  Stream<PlayerJournalEventRecord> stream();

  PlayerJournalEventRecordSource();

  /// Creates an event source that emits random player journal events.
  /// Only for test or demonstration purposes.
  factory PlayerJournalEventRecordSource.dummy() =>
      DummyPlayerJournalEventRecordSource();

  /// Creates an empty event source that does nothing.
  factory PlayerJournalEventRecordSource.empty() =>
      EmptyPlayerJournalEventRecordSource();

  /// Creates an event source that reads player journal events from local files.
  factory PlayerJournalEventRecordSource.local({final Directory? path}) {
    final journalPath = path ?? PlayerJournal.localJournalPath();
    if (journalPath == null) {
      return PlayerJournalEventRecordSource.empty();
    }
    return LocalPlayerJournalEventRecordSource(journalPath);
  }

  /// Creates an event source that connects to an external WebSocket server.
  factory PlayerJournalEventRecordSource.websocket(String host, int port) => WebsocketPlayerJournalEventRecordSource(host, port);
}

class EmptyPlayerJournalEventRecordSource extends PlayerJournalEventRecordSource {
  @override
  Stream<PlayerJournalEventRecord> stream() => const Stream.empty();
}

class DummyPlayerJournalEventRecordSource
    extends PlayerJournalEventRecordSource {
  final Random _random;
  Stream<PlayerJournalEventRecord>? _cachedStream;

  DummyPlayerJournalEventRecordSource() : _random = Random(1337);

  @override
  Stream<PlayerJournalEventRecord> stream() {
    _cachedStream ??= _buildStream().asBroadcastStream();
    return _cachedStream!;
  }

  Stream<PlayerJournalEventRecord> _buildStream() async* {
    final fileContent = await rootBundle
        .loadString('assets/dummy/Journal.YYYY-MM-DDTAAAAAA.BB.log');
    final lines = const LineSplitter().convert(fileContent);

    var isFirst = true;

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      if (!isFirst) {
        final delayMs = 200 + _random.nextInt(10000 - 200);
        await Future.delayed(Duration(milliseconds: delayMs));
      } else {
        isFirst = false;
      }

      final jsonMap = jsonDecode(line) as Map<String, dynamic>;
      jsonMap['timestamp'] = DateTime.now().toUtc().toIso8601String();
      yield PlayerJournalEventRecord.fromJson(jsonMap);
    }
  }
}

class LocalPlayerJournalEventRecordSource
    extends PlayerJournalEventRecordSource {
  final Directory _playerJournalPath;
  File? _currentJournalFile;
  Stream<PlayerJournalEventRecord>? _cachedStream;

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
      _currentJournalFile = await journal_log_file.currentJournalLogFile(
          playerJournalPath: _playerJournalPath);
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
    final lastFile = _currentJournalFile!;
    final lastPath = lastFile.path;
    _currentJournalFile = null;
    while (_currentJournalFile == null) {
      final possibleNextFile = await journal_log_file.nextJournalLogFile(
          playerJournalPath: _playerJournalPath, currentJournalFile: lastFile);
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
    final tailer =
        FileTailer.fromStart(journalFile, follow: true, bufferSize: 8192);
    tailer
        .stream()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .transform(PlayerJournalEventRecordDecoder())
        .forEach((record) async {
      ctrl.add(record);
      switch (record.event) {
        case PlayerJournalContinuedEventRecord.type:
          nextJournalLogFile(
              (record as PlayerJournalContinuedEventRecord).part);
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
  Stream<PlayerJournalEventRecord> stream() {
    _cachedStream ??= _buildStream().asBroadcastStream();
    return _cachedStream!;
  }

  Stream<PlayerJournalEventRecord> _buildStream() async* {
    yield* _stream(await currentJournalLogFile());
  }
}

class WebsocketPlayerJournalEventRecordSource extends PlayerJournalEventRecordSource {
  final String _host;
  final int _port;
  WebSocket? _socket;
  Stream<PlayerJournalEventRecord>? _cachedStream;

  WebsocketPlayerJournalEventRecordSource(this._host, this._port);

  @override
  Stream<PlayerJournalEventRecord> stream() {
    _cachedStream ??= _buildStream().asBroadcastStream();
    return _cachedStream!;
  }

  Stream<PlayerJournalEventRecord> _buildStream() async* {
    while (true) {
      StreamController<PlayerJournalEventRecord>? ctrl;
      try {
        _socket = await WebSocket.connect('ws://$_host:$_port');
        debugPrint('Connected to generic WebSocket E.D.N.A provider at ws://$_host:$_port');
        
        ctrl = StreamController<PlayerJournalEventRecord>();
        
        _socket!.listen(
          (message) {
            if (message is String) {
              try {
                final record = PlayerJournalEventRecord.fromString(message);
                ctrl!.add(record);
              } catch (e) {
                // Ignore parse errors from network
              }
            }
          },
          onDone: () async {
            await ctrl?.close();
          },
          onError: (error) async {
            await ctrl?.close();
          },
          cancelOnError: true
        );
        
        yield* ctrl.stream;
      } catch (e) {
        debugPrint('Websocket client connection error: $e. Retrying in 5s...');
      } finally {
        await ctrl?.close();
        _socket?.close();
        _socket = null;
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
