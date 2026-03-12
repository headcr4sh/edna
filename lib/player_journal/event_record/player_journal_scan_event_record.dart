import 'package:edna/player_journal/player_journal.dart';

class PlayerJournalScanEventRecord extends PlayerJournalEventRecord {
  static const type = 'Scan';

  final String? _bodyname;
  String? get bodyname => _bodyname;

  final double? _distancefromarrivalls;
  double? get distancefromarrivalls => _distancefromarrivalls;

  final bool? _tidallock;
  bool? get tidallock => _tidallock;

  final String? _terraformstate;
  String? get terraformstate => _terraformstate;

  final String? _planetclass;
  String? get planetclass => _planetclass;

  final String? _atmosphere;
  String? get atmosphere => _atmosphere;

  final String? _atmospheretype;
  String? get atmospheretype => _atmospheretype;

  final String? _volcanism;
  String? get volcanism => _volcanism;

  final double? _massem;
  double? get massem => _massem;

  final double? _radius;
  double? get radius => _radius;

  final double? _surfacegravity;
  double? get surfacegravity => _surfacegravity;

  final double? _surfacetemperature;
  double? get surfacetemperature => _surfacetemperature;

  final double? _surfacepressure;
  double? get surfacepressure => _surfacepressure;

  final bool? _landable;
  bool? get landable => _landable;

  final Map<String, dynamic>? _materials;
  Map<String, dynamic>? get materials => _materials;

  final double? _semimajoraxis;
  double? get semimajoraxis => _semimajoraxis;

  final double? _eccentricity;
  double? get eccentricity => _eccentricity;

  final double? _orbitalinclination;
  double? get orbitalinclination => _orbitalinclination;

  final double? _periapsis;
  double? get periapsis => _periapsis;

  final double? _orbitalperiod;
  double? get orbitalperiod => _orbitalperiod;

  final double? _rotationperiod;
  double? get rotationperiod => _rotationperiod;

  PlayerJournalScanEventRecord({
    required super.timestamp,
    final String? bodyname,
    final double? distancefromarrivalls,
    final bool? tidallock,
    final String? terraformstate,
    final String? planetclass,
    final String? atmosphere,
    final String? atmospheretype,
    final String? volcanism,
    final double? massem,
    final double? radius,
    final double? surfacegravity,
    final double? surfacetemperature,
    final double? surfacepressure,
    final bool? landable,
    final Map<String, dynamic>? materials,
    final double? semimajoraxis,
    final double? eccentricity,
    final double? orbitalinclination,
    final double? periapsis,
    final double? orbitalperiod,
    final double? rotationperiod,
  })
  : _bodyname = bodyname,
    _distancefromarrivalls = distancefromarrivalls,
    _tidallock = tidallock,
    _terraformstate = terraformstate,
    _planetclass = planetclass,
    _atmosphere = atmosphere,
    _atmospheretype = atmospheretype,
    _volcanism = volcanism,
    _massem = massem,
    _radius = radius,
    _surfacegravity = surfacegravity,
    _surfacetemperature = surfacetemperature,
    _surfacepressure = surfacepressure,
    _landable = landable,
    _materials = materials,
    _semimajoraxis = semimajoraxis,
    _eccentricity = eccentricity,
    _orbitalinclination = orbitalinclination,
    _periapsis = periapsis,
    _orbitalperiod = orbitalperiod,
    _rotationperiod = rotationperiod,
    super(event: PlayerJournalScanEventRecord.type);
}
