import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalMarketEventRecord extends PlayerJournalEventRecord {
  static const type = 'Market';

  final int? _marketid;
  int? get marketid => _marketid;

  final String? _stationname;
  String? get stationname => _stationname;

  final String? _stationtype;
  String? get stationtype => _stationtype;

  final String? _starsystem;
  String? get starsystem => _starsystem;

  PlayerJournalMarketEventRecord({
    required super.timestamp,
    final int? marketid,
    final String? stationname,
    final String? stationtype,
    final String? starsystem,
  })
  : _marketid = marketid,
    _stationname = stationname,
    _stationtype = stationtype,
    _starsystem = starsystem,
    super(event: PlayerJournalMarketEventRecord.type);
}
