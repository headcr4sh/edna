import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalDockedEventRecord extends PlayerJournalEventRecord {
  static const type = 'Docked';

  final String? _stationname;
  String? get stationname => _stationname;

  final String? _stationtype;
  String? get stationtype => _stationtype;

  final String? _starsystem;
  String? get starsystem => _starsystem;

  final String? _faction;
  String? get faction => _faction;

  final String? _factionstate;
  String? get factionstate => _factionstate;

  final String? _allegiance;
  String? get allegiance => _allegiance;

  final String? _economy;
  String? get economy => _economy;

  final String? _economyLocalised;
  String? get economyLocalised => _economyLocalised;

  final String? _government;
  String? get government => _government;

  final String? _governmentLocalised;
  String? get governmentLocalised => _governmentLocalised;

  final String? _security;
  String? get security => _security;

  final String? _securityLocalised;
  String? get securityLocalised => _securityLocalised;

  final int? _systemAddress;
  int? get systemAddress => _systemAddress;

  final int? _marketid;
  int? get marketid => _marketid;

  final String? _stationfaction;
  String? get stationfaction => _stationfaction;

  final String? _stationgovernment;
  String? get stationgovernment => _stationgovernment;

  final String? _stationgovernmentLocalised;
  String? get stationgovernmentLocalised => _stationgovernmentLocalised;

  final List<dynamic>? _stationservices;
  List<dynamic>? get stationservices => _stationservices;

  final String? _stationeconomy;
  String? get stationeconomy => _stationeconomy;

  final String? _stationeconomyLocalised;
  String? get stationeconomyLocalised => _stationeconomyLocalised;

  final List<dynamic>? _stationeconomies;
  List<dynamic>? get stationeconomies => _stationeconomies;

  final double? _distfromstarls;
  double? get distfromstarls => _distfromstarls;

  PlayerJournalDockedEventRecord({
    required super.timestamp,
    final String? stationname,
    final String? stationtype,
    final String? starsystem,
    final String? faction,
    final String? factionstate,
    final String? allegiance,
    final String? economy,
    final String? economyLocalised,
    final String? government,
    final String? governmentLocalised,
    final String? security,
    final String? securityLocalised,
    final int? systemAddress,
    final int? marketid,
    final String? stationfaction,
    final String? stationgovernment,
    final String? stationgovernmentLocalised,
    final List<dynamic>? stationservices,
    final String? stationeconomy,
    final String? stationeconomyLocalised,
    final List<dynamic>? stationeconomies,
    final double? distfromstarls,
  })
  : _stationname = stationname,
    _stationtype = stationtype,
    _starsystem = starsystem,
    _faction = faction,
    _factionstate = factionstate,
    _allegiance = allegiance,
    _economy = economy,
    _economyLocalised = economyLocalised,
    _government = government,
    _governmentLocalised = governmentLocalised,
    _security = security,
    _securityLocalised = securityLocalised,
    _systemAddress = systemAddress,
    _marketid = marketid,
    _stationfaction = stationfaction,
    _stationgovernment = stationgovernment,
    _stationgovernmentLocalised = stationgovernmentLocalised,
    _stationservices = stationservices,
    _stationeconomy = stationeconomy,
    _stationeconomyLocalised = stationeconomyLocalised,
    _stationeconomies = stationeconomies,
    _distfromstarls = distfromstarls,
    super(event: PlayerJournalDockedEventRecord.type);
}
