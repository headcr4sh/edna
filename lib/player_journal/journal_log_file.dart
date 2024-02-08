import 'dart:io';
import 'package:edna/player_journal/journal_path.dart';
import 'package:path/path.dart' as path;

/// Regular expression to match the format of Journal files as we know them.
RegExp journalFilePattern = RegExp(r'^Journal\.(?<serial01>.*?)\.(?<serial02>\d+)\.log$');

Future<File?> currentJournalLogFile({required Directory playerJournalPath}) async {
    var journalFile = await playerJournalPath.list().fold<File?>(null, (previous, element) {
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
  return journalFile;
}
