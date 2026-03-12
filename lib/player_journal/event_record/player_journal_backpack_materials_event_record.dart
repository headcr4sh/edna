import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalBackpackMaterialsEventRecord extends PlayerJournalEventRecord {
  static const type = 'BackpackMaterials';

  final List<dynamic>? _items;
  List<dynamic>? get items => _items;

  final List<dynamic>? _components;
  List<dynamic>? get components => _components;

  final List<dynamic>? _consumables;
  List<dynamic>? get consumables => _consumables;

  final List<dynamic>? _data;
  List<dynamic>? get data => _data;

  PlayerJournalBackpackMaterialsEventRecord({
    required super.timestamp,
    final List<dynamic>? items,
    final List<dynamic>? components,
    final List<dynamic>? consumables,
    final List<dynamic>? data,
  })
  : _items = items,
    _components = components,
    _consumables = consumables,
    _data = data,
    super(event: PlayerJournalBackpackMaterialsEventRecord.type);
}
