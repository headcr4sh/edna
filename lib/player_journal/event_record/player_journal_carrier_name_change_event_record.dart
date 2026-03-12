import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalCarrierNameChangeEventRecord extends PlayerJournalEventRecord {
  static const type = 'CarrierNameChange';

  final int? _carrierid;
  int? get carrierid => _carrierid;

  final String? _name;
  String? get name => _name;

  final String? _callsign;
  String? get callsign => _callsign;

  PlayerJournalCarrierNameChangeEventRecord({
    required super.timestamp,
    final int? carrierid,
    final String? name,
    final String? callsign,
  })
  : _carrierid = carrierid,
    _name = name,
    _callsign = callsign,
    super(event: PlayerJournalCarrierNameChangeEventRecord.type);
}
