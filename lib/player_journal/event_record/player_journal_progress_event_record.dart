import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalProgressEventRecord extends PlayerJournalEventRecord {

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

  static const type = 'Progress';
  PlayerJournalProgressEventRecord({
    required super.timestamp,
    required int combat,
    required int trade,
    required int explore,
    required int empire,
    required int federation,
    required int cqc,
  }):
      _combat = combat,
      _trade = trade,
      _explore = explore,
      _empire = empire,
      _federation = federation,
      _cqc = cqc,
      super(event: PlayerJournalProgressEventRecord.type);
}
