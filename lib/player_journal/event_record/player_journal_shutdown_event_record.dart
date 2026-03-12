import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalShutdownEventRecord extends PlayerJournalEventRecord {
  static const type = 'Shutdown';
  PlayerJournalShutdownEventRecord({ required super.timestamp }): super(event: PlayerJournalShutdownEventRecord.type);
}
