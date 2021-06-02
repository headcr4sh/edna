import 'dart:convert' show utf8, LineSplitter;
import 'dart:io' show File;

import './file_tailer.dart';
import './player_journal_event_record_source.dart';

void main(final List<String> args) {
  String filename;
  if (args.isEmpty) {
    filename = LocalPlayerJournalEventRecordSource.defaultPath();
  } else {
    filename = args.first;
  }
  FileTailer(File(filename)).stream()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) => print("${line}\n"));
}
