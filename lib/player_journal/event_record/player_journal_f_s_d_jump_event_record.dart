import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalFSDJumpEventRecord extends PlayerJournalEventRecord {
  static const type = 'FSDJump';

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

  final double? _jumpdist;
  double? get jumpdist => _jumpdist;

  final double? _fuelused;
  double? get fuelused => _fuelused;

  final double? _fuellevel;
  double? get fuellevel => _fuellevel;

  final String? _faction;
  String? get faction => _faction;

  final String? _factionstate;
  String? get factionstate => _factionstate;

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

  final List<dynamic>? _factions;
  List<dynamic>? get factions => _factions;

  final String? _systemfaction;
  String? get systemfaction => _systemfaction;

  PlayerJournalFSDJumpEventRecord({
    required super.timestamp,
    final String? starsystem,
    final List<dynamic>? starpos,
    final String? allegiance,
    final String? economy,
    final String? economyLocalised,
    final String? government,
    final String? governmentLocalised,
    final String? security,
    final String? securityLocalised,
    final double? jumpdist,
    final double? fuelused,
    final double? fuellevel,
    final String? faction,
    final String? factionstate,
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
    final List<dynamic>? factions,
    final String? systemfaction,
  })
  : _starsystem = starsystem,
    _starpos = starpos,
    _allegiance = allegiance,
    _economy = economy,
    _economyLocalised = economyLocalised,
    _government = government,
    _governmentLocalised = governmentLocalised,
    _security = security,
    _securityLocalised = securityLocalised,
    _jumpdist = jumpdist,
    _fuelused = fuelused,
    _fuellevel = fuellevel,
    _faction = faction,
    _factionstate = factionstate,
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
    _factions = factions,
    _systemfaction = systemfaction,
    super(event: PlayerJournalFSDJumpEventRecord.type);
}
