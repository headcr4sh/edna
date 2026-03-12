import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalContinuedEventRecord extends PlayerJournalEventRecord {

  static const type = 'Continued';

  final int _part;
  int get part => _part;

  PlayerJournalContinuedEventRecord({
    required super.timestamp,
    required final int part,
  })
      : _part = part,
        super(event: PlayerJournalContinuedEventRecord.type);
}
