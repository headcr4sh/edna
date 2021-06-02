import 'dart:io' as io;

import 'player_journal/player_journal_event_record_source.dart';
import 'package:flutter/material.dart' show runApp;
import 'init_nonweb.dart' if (dart.library.html) 'init_web.dart' show configureApp;

import './app.dart' show EdnaApp;
import 'app_init_arguments.dart' show EdnaAppInitArguments;

void main(final List<String> args) {
  configureApp();
  final initArgs = EdnaAppInitArguments.assemble(args);
  if (initArgs.showGui) {
    runApp(EdnaApp(initArgs));
  } else {
    PlayerJournalEventRecordSource.local().stream().forEach((event) {
      io.stdout.writeln(event);
    });
  }
}

