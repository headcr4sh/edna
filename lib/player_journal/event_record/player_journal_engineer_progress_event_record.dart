import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalEngineerProgressEventRecord extends PlayerJournalEventRecord {
  static const type = 'EngineerProgress';

  final String? _engineer;
  String? get engineer => _engineer;

  final String? _progress;
  String? get progress => _progress;

  final int? _engineerid;
  int? get engineerid => _engineerid;

  final int? _rank;
  int? get rank => _rank;

  final List<dynamic>? _engineers;
  List<dynamic>? get engineers => _engineers;

  PlayerJournalEngineerProgressEventRecord({
    required super.timestamp,
    final String? engineer,
    final String? progress,
    final int? engineerid,
    final int? rank,
    final List<dynamic>? engineers,
  })
  : _engineer = engineer,
    _progress = progress,
    _engineerid = engineerid,
    _rank = rank,
    _engineers = engineers,
    super(event: PlayerJournalEngineerProgressEventRecord.type);
}
