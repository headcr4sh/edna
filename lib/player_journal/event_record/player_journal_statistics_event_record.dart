import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalStatisticsEventRecord extends PlayerJournalEventRecord {
  static const type = 'Statistics';

  final Map<String, dynamic>? _bankAccount;
  Map<String, dynamic>? get bankAccount => _bankAccount;

  final Map<String, dynamic>? _combat;
  Map<String, dynamic>? get combat => _combat;

  final Map<String, dynamic>? _crime;
  Map<String, dynamic>? get crime => _crime;

  final Map<String, dynamic>? _smuggling;
  Map<String, dynamic>? get smuggling => _smuggling;

  final Map<String, dynamic>? _trading;
  Map<String, dynamic>? get trading => _trading;

  final Map<String, dynamic>? _mining;
  Map<String, dynamic>? get mining => _mining;

  final Map<String, dynamic>? _exploration;
  Map<String, dynamic>? get exploration => _exploration;

  final Map<String, dynamic>? _passengers;
  Map<String, dynamic>? get passengers => _passengers;

  final Map<String, dynamic>? _searchAndRescue;
  Map<String, dynamic>? get searchAndRescue => _searchAndRescue;

  final Map<String, dynamic>? _tgEncounters;
  Map<String, dynamic>? get tgEncounters => _tgEncounters;

  final Map<String, dynamic>? _crafting;
  Map<String, dynamic>? get crafting => _crafting;

  final Map<String, dynamic>? _crew;
  Map<String, dynamic>? get crew => _crew;

  final Map<String, dynamic>? _multicrew;
  Map<String, dynamic>? get multicrew => _multicrew;

  final Map<String, dynamic>? _materialTraderStats;
  Map<String, dynamic>? get materialTraderStats => _materialTraderStats;

  final Map<String, dynamic>? _cqc;
  Map<String, dynamic>? get cqc => _cqc;

  final Map<String, dynamic>? _fleetcarrier;
  Map<String, dynamic>? get fleetcarrier => _fleetcarrier;

  PlayerJournalStatisticsEventRecord({
    required super.timestamp,
    final Map<String, dynamic>? bankAccount,
    final Map<String, dynamic>? combat,
    final Map<String, dynamic>? crime,
    final Map<String, dynamic>? smuggling,
    final Map<String, dynamic>? trading,
    final Map<String, dynamic>? mining,
    final Map<String, dynamic>? exploration,
    final Map<String, dynamic>? passengers,
    final Map<String, dynamic>? searchAndRescue,
    final Map<String, dynamic>? tgEncounters,
    final Map<String, dynamic>? crafting,
    final Map<String, dynamic>? crew,
    final Map<String, dynamic>? multicrew,
    final Map<String, dynamic>? materialTraderStats,
    final Map<String, dynamic>? cqc,
    final Map<String, dynamic>? fleetcarrier,
  })
  : _bankAccount = bankAccount,
    _combat = combat,
    _crime = crime,
    _smuggling = smuggling,
    _trading = trading,
    _mining = mining,
    _exploration = exploration,
    _passengers = passengers,
    _searchAndRescue = searchAndRescue,
    _tgEncounters = tgEncounters,
    _crafting = crafting,
    _crew = crew,
    _multicrew = multicrew,
    _materialTraderStats = materialTraderStats,
    _cqc = cqc,
    _fleetcarrier = fleetcarrier,
    super(event: PlayerJournalStatisticsEventRecord.type);
}
