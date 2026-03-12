import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalEngineerCraftEventRecord extends PlayerJournalEventRecord {
  static const type = 'EngineerCraft';

  final String? _engineer;
  String? get engineer => _engineer;

  final String? _blueprint;
  String? get blueprint => _blueprint;

  final int? _level;
  int? get level => _level;

  final Map<String, dynamic>? _ingredients;
  Map<String, dynamic>? get ingredients => _ingredients;

  PlayerJournalEngineerCraftEventRecord({
    required super.timestamp,
    final String? engineer,
    final String? blueprint,
    final int? level,
    final Map<String, dynamic>? ingredients,
  })
  : _engineer = engineer,
    _blueprint = blueprint,
    _level = level,
    _ingredients = ingredients,
    super(event: PlayerJournalEngineerCraftEventRecord.type);
}
