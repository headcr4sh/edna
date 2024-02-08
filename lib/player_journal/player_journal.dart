library edna.player_journal;

export './player_journal_event_record.dart';
export './player_journal_event_record_codec.dart';
export './player_journal_event_record_log_widget.dart';
export './player_journal_event_record_source.dart';
export './player_journal_event_type.dart';
export './status.dart';

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:edna/player_journal/json_file.dart' show JsonFile;
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:logger/logger.dart' show Logger;

import './status.dart';

final logger = Logger();

class PlayerJournal with ChangeNotifier {

  static Directory localJournalPath() {
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
    return Directory(edJournalPath);
  }

  static final PlayerJournal _instance = PlayerJournal._internal();

  factory PlayerJournal() => _instance;

  late JsonFile<Status> _status;

  Status get status => _status.model ?? Status(timestamp: DateTime.parse('1970-01-01T00:00:00Z'), event: 'Status', flags: 0);

  PlayerJournal._internal() {
    // TODO implement switch between local and remote event sources.
    // TODO fill with contents from JSON files found in the journal dir.

    onChange() => notifyListeners();

    _status = JsonFile(file: File(path.join(PlayerJournal.localJournalPath().absolute.path, 'Status.json')), decoder: Status.fromJson);
    _status.addListener(onChange);

    Timer.periodic(const Duration(seconds: 30), (timer) {
      // We might have gone offline and the one way to tell is by checking the last timestamp
      // of the status event.
      if (status.offline) {
        onChange();
      }
    });
    onChange();
  }
}
