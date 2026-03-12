import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalCarrierStatsEventRecord extends PlayerJournalEventRecord {
  static const type = 'CarrierStats';

  final int? _carrierid;
  int? get carrierid => _carrierid;

  final String? _callsign;
  String? get callsign => _callsign;

  final String? _name;
  String? get name => _name;

  final String? _dockingaccess;
  String? get dockingaccess => _dockingaccess;

  final bool? _allownotorious;
  bool? get allownotorious => _allownotorious;

  final int? _fuellevel;
  int? get fuellevel => _fuellevel;

  final double? _jumprangecurr;
  double? get jumprangecurr => _jumprangecurr;

  final double? _jumprangemax;
  double? get jumprangemax => _jumprangemax;

  final bool? _pendingdecommission;
  bool? get pendingdecommission => _pendingdecommission;

  final Map<String, dynamic>? _spaceusage;
  Map<String, dynamic>? get spaceusage => _spaceusage;

  final Map<String, dynamic>? _finance;
  Map<String, dynamic>? get finance => _finance;

  final List<dynamic>? _crew;
  List<dynamic>? get crew => _crew;

  final List<dynamic>? _shippacks;
  List<dynamic>? get shippacks => _shippacks;

  final List<dynamic>? _modulepacks;
  List<dynamic>? get modulepacks => _modulepacks;

  PlayerJournalCarrierStatsEventRecord({
    required super.timestamp,
    final int? carrierid,
    final String? callsign,
    final String? name,
    final String? dockingaccess,
    final bool? allownotorious,
    final int? fuellevel,
    final double? jumprangecurr,
    final double? jumprangemax,
    final bool? pendingdecommission,
    final Map<String, dynamic>? spaceusage,
    final Map<String, dynamic>? finance,
    final List<dynamic>? crew,
    final List<dynamic>? shippacks,
    final List<dynamic>? modulepacks,
  })
  : _carrierid = carrierid,
    _callsign = callsign,
    _name = name,
    _dockingaccess = dockingaccess,
    _allownotorious = allownotorious,
    _fuellevel = fuellevel,
    _jumprangecurr = jumprangecurr,
    _jumprangemax = jumprangemax,
    _pendingdecommission = pendingdecommission,
    _spaceusage = spaceusage,
    _finance = finance,
    _crew = crew,
    _shippacks = shippacks,
    _modulepacks = modulepacks,
    super(event: PlayerJournalCarrierStatsEventRecord.type);
}
