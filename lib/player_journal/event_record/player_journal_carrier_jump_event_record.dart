import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalCarrierJumpEventRecord extends PlayerJournalEventRecord {
  static const type = 'CarrierJump';

  final bool? _docked;
  bool? get docked => _docked;

  final String? _stationname;
  String? get stationname => _stationname;

  final String? _stationtype;
  String? get stationtype => _stationtype;

  final int? _marketid;
  int? get marketid => _marketid;

  final Map<String, dynamic>? _stationfaction;
  Map<String, dynamic>? get stationfaction => _stationfaction;

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

  final bool? _taxi;
  bool? get taxi => _taxi;

  final bool? _multicrew;
  bool? get multicrew => _multicrew;

  final String? _starsystem;
  String? get starsystem => _starsystem;

  final int? _systemAddress;
  int? get systemAddress => _systemAddress;

  final List<dynamic>? _starpos;
  List<dynamic>? get starpos => _starpos;

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

  final String? _body;
  String? get body => _body;

  final int? _bodyId;
  int? get bodyId => _bodyId;

  final String? _bodytype;
  String? get bodytype => _bodytype;

  final String? _controllingpower;
  String? get controllingpower => _controllingpower;

  final List<dynamic>? _powers;
  List<dynamic>? get powers => _powers;

  final String? _powerplaystate;
  String? get powerplaystate => _powerplaystate;

  final double? _powerplaystatecontrolprogress;
  double? get powerplaystatecontrolprogress => _powerplaystatecontrolprogress;

  final int? _powerplaystatereinforcement;
  int? get powerplaystatereinforcement => _powerplaystatereinforcement;

  final int? _powerplaystateundermining;
  int? get powerplaystateundermining => _powerplaystateundermining;

  final List<dynamic>? _factions;
  List<dynamic>? get factions => _factions;

  final Map<String, dynamic>? _systemfaction;
  Map<String, dynamic>? get systemfaction => _systemfaction;

  PlayerJournalCarrierJumpEventRecord({
    required super.timestamp,
    final bool? docked,
    final String? stationname,
    final String? stationtype,
    final int? marketid,
    final Map<String, dynamic>? stationfaction,
    final String? stationgovernment,
    final String? stationgovernmentLocalised,
    final List<dynamic>? stationservices,
    final String? stationeconomy,
    final String? stationeconomyLocalised,
    final List<dynamic>? stationeconomies,
    final bool? taxi,
    final bool? multicrew,
    final String? starsystem,
    final int? systemAddress,
    final List<dynamic>? starpos,
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
    final String? body,
    final int? bodyId,
    final String? bodytype,
    final String? controllingpower,
    final List<dynamic>? powers,
    final String? powerplaystate,
    final double? powerplaystatecontrolprogress,
    final int? powerplaystatereinforcement,
    final int? powerplaystateundermining,
    final List<dynamic>? factions,
    final Map<String, dynamic>? systemfaction,
  })
  : _docked = docked,
    _stationname = stationname,
    _stationtype = stationtype,
    _marketid = marketid,
    _stationfaction = stationfaction,
    _stationgovernment = stationgovernment,
    _stationgovernmentLocalised = stationgovernmentLocalised,
    _stationservices = stationservices,
    _stationeconomy = stationeconomy,
    _stationeconomyLocalised = stationeconomyLocalised,
    _stationeconomies = stationeconomies,
    _taxi = taxi,
    _multicrew = multicrew,
    _starsystem = starsystem,
    _systemAddress = systemAddress,
    _starpos = starpos,
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
    _body = body,
    _bodyId = bodyId,
    _bodytype = bodytype,
    _controllingpower = controllingpower,
    _powers = powers,
    _powerplaystate = powerplaystate,
    _powerplaystatecontrolprogress = powerplaystatecontrolprogress,
    _powerplaystatereinforcement = powerplaystatereinforcement,
    _powerplaystateundermining = powerplaystateundermining,
    _factions = factions,
    _systemfaction = systemfaction,
    super(event: PlayerJournalCarrierJumpEventRecord.type);
}
