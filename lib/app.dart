import 'dart:io' show Platform;
import 'package:args/args.dart';
import 'package:flutter/material.dart';

import 'app_init_arguments.dart';
import 'app_mode.dart';
import 'player_journal/player_journal.dart'
    show PlayerJournalEventRecordLogWidget;

class EdnaApp extends StatelessWidget {
  final EdnaAppMode _mode;

  EdnaAppMode get mode => _mode;

  EdnaApp(final EdnaAppInitArguments initArguments)
      : _mode = initArguments.mode;

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'E.D.N.A.',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: PlayerJournalEventRecordLogWidget.forMode(mode: mode),
    );
  }
}
