import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalCommanderEventRecord extends PlayerJournalEventRecord {

  static const type = 'Commander';

  final String _fid;
  String get fid => _fid;

  final String _name;
  String get name => _name;

  PlayerJournalCommanderEventRecord({
    required super.timestamp,
    required final String fid,
    required final String name,
  })
  : _fid = fid,
    _name = name,
    super(event: PlayerJournalCommanderEventRecord.type);
}
