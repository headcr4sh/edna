import 'package:edna/player_journal/player_journal.dart';
import 'package:test/test.dart';

void main() {
  group('PlayerJournalEventRecord', () {
    test('.fromString(<<Fileheader>>)', () {
      final eventRecord = PlayerJournalEventRecord.fromString(r'{ "timestamp":"2021-04-30T09:01:00Z", "event":"Fileheader", "part":1, "language":"English\\UK", "gameversion":"Fleet Carriers Update - Patch 11", "build":"r254828/r0 " }') as PlayerJournalFileheaderEventRecord;
      expect(eventRecord.event, PlayerJournalFileheaderEventRecord.type);
      expect(eventRecord.part, 1);
      expect(eventRecord.language, 'English\\UK');
      expect(eventRecord.gameVersion, 'Fleet Carriers Update - Patch 11');
      expect(eventRecord.build, 'r254828/r0');
    });
  });
}
