import 'dart:io';
import 'package:path/path.dart' as path;

/// Regular expression to match the format of Journal files as we know them.
RegExp journalFilePattern = RegExp(r'^Journal\.(?<datestamp>.*?)\.(?<part>\d+)\.log$');

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
      if (match.namedGroup('datestamp')!.compareTo(prevMatch!.namedGroup('datestamp')!) >= 0 &&
          match.namedGroup('part')!.compareTo(prevMatch.namedGroup('part')!) >= 0) {
        return element is File ? element : null;
      }
    }
    return null;
  });
  return journalFile;
}

Future<File?> nextJournalLogFile({required Directory playerJournalPath, required File currentJournalFile}) async {
  final possibleNextFile = await currentJournalLogFile(playerJournalPath: playerJournalPath);
  if (possibleNextFile?.path != currentJournalFile.path) {
    return possibleNextFile;
  }
  return null;
}
