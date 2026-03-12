import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalLocationEventRecord extends PlayerJournalEventRecord {
  static const type = 'Location';

  final bool? _docked;
  bool? get docked => _docked;

  final String? _stationname;
  String? get stationname => _stationname;

  final String? _stationtype;
  String? get stationtype => _stationtype;

  final String? _starsystem;
  String? get starsystem => _starsystem;

  final List<dynamic>? _starpos;
  List<dynamic>? get starpos => _starpos;

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

  final String? _body;
  String? get body => _body;

  final String? _bodytype;
  String? get bodytype => _bodytype;

  final String? _faction;
  String? get faction => _faction;

  final String? _factionstate;
  String? get factionstate => _factionstate;

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

  final int? _systemAddress;
  int? get systemAddress => _systemAddress;

  final String? _systemallegiance;
  String? get systemallegiance => _systemallegiance;

  final String? _systemeconomy;
  String? get systemeconomy => _systemeconomy;

  final String? _systemeconomyLocalised;
  String? get systemeconomyLocalised => _systemeconomyLocalised;

  final String? _systemsecondeconomy;
  String? get systemsecondeconomy => _systemsecondeconomy;

  final String? _systemsecondeconomyLocalised;
  String? get systemsecondeconomyLocalised => _systemsecondeconomyLocalised;

  final String? _systemgovernment;
  String? get systemgovernment => _systemgovernment;

  final String? _systemgovernmentLocalised;
  String? get systemgovernmentLocalised => _systemgovernmentLocalised;

  final String? _systemsecurity;
  String? get systemsecurity => _systemsecurity;

  final String? _systemsecurityLocalised;
  String? get systemsecurityLocalised => _systemsecurityLocalised;

  final int? _population;
  int? get population => _population;

  final int? _bodyId;
  int? get bodyId => _bodyId;

  final List<dynamic>? _factions;
  List<dynamic>? get factions => _factions;

  final String? _systemfaction;
  String? get systemfaction => _systemfaction;

  PlayerJournalLocationEventRecord({
    required super.timestamp,
    final bool? docked,
    final String? stationname,
    final String? stationtype,
    final String? starsystem,
    final List<dynamic>? starpos,
    final String? allegiance,
    final String? economy,
    final String? economyLocalised,
    final String? government,
    final String? governmentLocalised,
    final String? security,
    final String? securityLocalised,
    final String? body,
    final String? bodytype,
    final String? faction,
    final String? factionstate,
    final int? marketid,
    final String? stationfaction,
    final String? stationgovernment,
    final String? stationgovernmentLocalised,
    final List<dynamic>? stationservices,
    final String? stationeconomy,
    final String? stationeconomyLocalised,
    final List<dynamic>? stationeconomies,
    final int? systemAddress,
    final String? systemallegiance,
    final String? systemeconomy,
    final String? systemeconomyLocalised,
    final String? systemsecondeconomy,
    final String? systemsecondeconomyLocalised,
    final String? systemgovernment,
    final String? systemgovernmentLocalised,
    final String? systemsecurity,
    final String? systemsecurityLocalised,
    final int? population,
    final int? bodyId,
    final List<dynamic>? factions,
    final String? systemfaction,
  })
  : _docked = docked,
    _stationname = stationname,
    _stationtype = stationtype,
    _starsystem = starsystem,
    _starpos = starpos,
    _allegiance = allegiance,
    _economy = economy,
    _economyLocalised = economyLocalised,
    _government = government,
    _governmentLocalised = governmentLocalised,
    _security = security,
    _securityLocalised = securityLocalised,
    _body = body,
    _bodytype = bodytype,
    _faction = faction,
    _factionstate = factionstate,
    _marketid = marketid,
    _stationfaction = stationfaction,
    _stationgovernment = stationgovernment,
    _stationgovernmentLocalised = stationgovernmentLocalised,
    _stationservices = stationservices,
    _stationeconomy = stationeconomy,
    _stationeconomyLocalised = stationeconomyLocalised,
    _stationeconomies = stationeconomies,
    _systemAddress = systemAddress,
    _systemallegiance = systemallegiance,
    _systemeconomy = systemeconomy,
    _systemeconomyLocalised = systemeconomyLocalised,
    _systemsecondeconomy = systemsecondeconomy,
    _systemsecondeconomyLocalised = systemsecondeconomyLocalised,
    _systemgovernment = systemgovernment,
    _systemgovernmentLocalised = systemgovernmentLocalised,
    _systemsecurity = systemsecurity,
    _systemsecurityLocalised = systemsecurityLocalised,
    _population = population,
    _bodyId = bodyId,
    _factions = factions,
    _systemfaction = systemfaction,
    super(event: PlayerJournalLocationEventRecord.type);
}
