import 'dart:io' show Directory;
import 'package:edna/player_journal/journal_log_file.dart';
import 'package:edna/player_journal/player_journal.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('PlayerJournalEventSource', () {
    test('.journalFilePattern() recognizes valid Journal file names', () {
      final regexMatch = journalFilePattern.firstMatch('Journal.210323223612.01.log');
      expect(regexMatch != null, true);
      expect(regexMatch!.namedGroup('serial01'), '210323223612');
      expect(regexMatch.namedGroup('serial02'), '01');
    });
    test('.journalFilePattern() ignores invalid Journal file names', () {
      final regexMatch = journalFilePattern.firstMatch('NotAJournal.210323223612.01.log');
      expect(regexMatch == null, true);
    });
    test('.local(path: \$testdata).currentJournalFile() finds the latest journal file', () async {
      final journalPath = Directory(path.join(path.current, 'test', 'player_journal', 'testdata', 'journal01'));
      assert(journalPath.existsSync());
      final eventSource = PlayerJournalEventRecordSource.local(path: journalPath) as LocalPlayerJournalEventRecordSource;
      final currentJournalFile = await eventSource.currentJournalLogFile(forceRefresh: true);
      expect(path.basename(currentJournalFile.path), 'Journal.210430110100.01.log');
    });
    test('.local(path: \$testdata).stream().first works as supposed to', () async {
      final journalPath = Directory(path.join(path.current, 'test', 'player_journal', 'testdata', 'journal01'));
      assert(journalPath.existsSync());
      final eventSource = PlayerJournalEventRecordSource.local(path: journalPath);
      final stream = eventSource.stream();
      final firstRecord = await stream.first;
      expect(firstRecord.event, PlayerJournalFileheaderEventRecord.type);
    });
  });
}
