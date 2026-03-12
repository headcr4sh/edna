// No library name needed

export './event_record/player_journal_event_record.dart';
export './player_journal_event_record_codec.dart';
export './player_journal_event_record_log_widget.dart';
export './player_journal_event_record_source.dart';
export './player_journal_event_type.dart';
export './status.dart';

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:edna/app_settings.dart' show EdnaAppSettings;
import 'package:edna/player_journal/json_file.dart' show JsonFile;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import './status.dart';

final logger = Logger();

class PlayerJournal with ChangeNotifier {
  static Directory? localJournalPath() {
    final String edJournalPath;
    final ednaJournalDirEnv = Platform.environment['EDNA_JOURNAL_DIR'];
    final edJournalDirEnv = Platform.environment['ED_JOURNAL_DIR'];
    final configOverride = EdnaAppSettings().journalDirOverride;

    if (configOverride != null && configOverride.isNotEmpty) {
      edJournalPath = configOverride;
    } else if (ednaJournalDirEnv != null) {
      edJournalPath = ednaJournalDirEnv;
    } else if (edJournalDirEnv != null) {
      edJournalPath = edJournalDirEnv;
    } else if (Platform.isWindows) {
      final userHomePath = Platform.environment['USERPROFILE'];
      if (userHomePath == null || userHomePath.isEmpty) {
        return null;
      }
      edJournalPath = path.join(userHomePath, 'Saved Games',
          'Frontier Developments', 'Elite Dangerous');
    } else if (Platform.isLinux) {
      final userHomePath = Platform.environment['HOME'];
      if (userHomePath == null || userHomePath.isEmpty) {
        return null;
      }
      edJournalPath = path.joinAll([
        userHomePath,
        '.local',
        'share',
        'Steam',
        'steamapps',
        'compatdata',
        '359320',
        'pfx',
        'drive_c',
        'users',
        'steamuser',
        'Saved Games',
        'Frontier Developments',
        'Elite Dangerous'
      ]);
    } else {
      return null;
    }
    final directory = Directory(edJournalPath);
    return directory.existsSync() ? directory : null;
  }

  static final PlayerJournal _instance = PlayerJournal._internal();

  factory PlayerJournal() => _instance;

  late JsonFile<Status>? _status;

  Status get status =>
      (_status?.model) ??
      Status(
          timestamp: DateTime.fromMillisecondsSinceEpoch(0),
          event: 'Status',
          flags: 0);

  PlayerJournal._internal() {
    onChange() => notifyListeners();

    final journalPath = PlayerJournal.localJournalPath();
    if (journalPath != null) {
      _status = JsonFile(
          file: File(path.join(journalPath.absolute.path, 'Status.json')),
          decoder: Status.fromJson);
      _status!.addListener(onChange);

      Timer.periodic(const Duration(seconds: 30), (timer) {
        if (status.offline) {
          onChange();
        }
      });
    } else {
      _status = null;
    }
    onChange();
  }
}
