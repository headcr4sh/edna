import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalSynthesisEventRecord extends PlayerJournalEventRecord {
  static const type = 'Synthesis';

  final String? _name;
  String? get name => _name;

  final Map<String, dynamic>? _materials;
  Map<String, dynamic>? get materials => _materials;

  PlayerJournalSynthesisEventRecord({
    required super.timestamp,
    final String? name,
    final Map<String, dynamic>? materials,
  })
  : _name = name,
    _materials = materials,
    super(event: PlayerJournalSynthesisEventRecord.type);
}
