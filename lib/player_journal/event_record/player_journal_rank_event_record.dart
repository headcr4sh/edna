import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalRankEventRecord extends PlayerJournalEventRecord {
  static const type = 'Rank';

  final int _combat;
  int get combat => _combat;

  final int _trade;
  int get trade => _trade;

  final int _explore;
  int get explore => _explore;

  final int _empire;
  int get empire => _empire;

  final int _federation;
  int get federation => _federation;

  final int _cqc;
  int get cqc => _cqc;

  PlayerJournalRankEventRecord({
    required super.timestamp,
    required final int combat,
    required final int trade,
    required final int explore,
    required final int empire,
    required final int federation,
    required final int cqc,
  })
  : _combat = combat,
    _trade = trade,
    _explore = explore,
    _empire = empire,
    _federation = federation,
    _cqc = cqc,
    super(event: PlayerJournalRankEventRecord.type);
}
