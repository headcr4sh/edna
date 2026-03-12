import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalBackpackEventRecord extends PlayerJournalEventRecord {
  static const type = 'Backpack';

  PlayerJournalBackpackEventRecord({
    required super.timestamp,
  })
  : super(event: PlayerJournalBackpackEventRecord.type);
}
