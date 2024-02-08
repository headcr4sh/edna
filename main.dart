import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:edna/player_journal/file_tailer.dart';
import 'package:edna/player_journal/journal_log_file.dart';
import 'package:edna/player_journal/player_journal.dart';

void main() async {
  final ctrl = StreamController<PlayerJournalEventRecord>();
  final journalLogFile = await currentJournalLogFile(playerJournalPath: PlayerJournal.localJournalPath());
  if (journalLogFile == null) {
    throw Exception('No Journal log file found.');
  }
  print('Journal log file: $journalLogFile');

  final tailer = FileTailer(journalLogFile);
  print('Using file: ${tailer.file.path}, exists: ${tailer.file.existsSync() ? "yes" : "no"}');
  await tailer
      .stream()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .transform(PlayerJournalEventRecordDecoder())
      .forEach((event) async {
    print(event);
    if (event.event == PlayerJournalShutdownEventRecord.type) {
      await ctrl.close();
      tailer.cancel();
    }
  });
}
