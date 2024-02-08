import 'package:flutter/material.dart' show ChangeNotifier;

/// Docked, (on a landing pad)
final _flagDocked = 0x00000001;

/// Landed, (on planet surface)
final _flagLanded = 0x00000002;

/// Landing Gear Down
final _flagLandingGearDown = 0x00000004;

/// Shields Up
final _flagShieldsUp = 0x00000008;

/// Supercruise
final _flagSupercruise = 0x00000016;

// Flight assist off
final _flagFlightAssistOff = 0x00000032;

/// ...

/// Hud in Analysis mode
final _flagHudInAnalysisMode = 0x08000000;

enum GuiFocus {
  noFocus,
  internalPanel,
  externalPanel,
  commsPanel,
  rolePanel,
  stationServices,
  galaxyMap,
  systemMap,
  orrery,
  fssMode,
  ssaMode,
  codex,
}

enum HudMode {
  combat,
  analysis,
}

/// See: https://elite-journal.readthedocs.io/en/latest/Status%20File/
class Status with ChangeNotifier {
  DateTime _timestamp;
  String _event;
  int _flags;
  int _guiFocus;

  bool get online => DateTime.now().difference(_timestamp).inSeconds < 60;
  bool get offline => !online;

  bool _isFlagSet(final int flag) => _flags & flag == flag;

  bool get docked => _isFlagSet(_flagDocked);
  bool get landed => _isFlagSet(_flagLanded);
  bool get landingGearDown => _isFlagSet(_flagLandingGearDown);
  bool get shieldsUp => _isFlagSet(_flagShieldsUp);
  bool get supercruise => _isFlagSet(_flagSupercruise);
  bool get flightAssistOff => _isFlagSet(_flagFlightAssistOff);
  bool get hudInAnalysisMode => _isFlagSet(_flagHudInAnalysisMode);
  bool get hudInCombatMode => !_isFlagSet(_flagHudInAnalysisMode);
  HudMode get hudMode => hudInAnalysisMode ? HudMode.analysis : HudMode.combat;

  GuiFocus get guiFocus => GuiFocus.values[_guiFocus];

  Status({
    required DateTime timestamp,
    required String event,
    required int flags,
    int guiFocus = 0,
  })  : _timestamp = timestamp,
        _event = event,
        _flags = flags,
        _guiFocus = guiFocus;


  factory Status.fromJson(Map<String, dynamic> json) {
    assert (json['timestamp'] is String);
    assert (json['event'] is String);
    assert (json['Flags'] is int);
    assert (json['GuiFocus'] == null || json['GuiFocus'] is String);
    return Status(
      timestamp: DateTime.parse(json['timestamp'] as String),
      event: json['event'] as String,
      flags: json['Flags'] as int,
      guiFocus: json['GuiFocus'] as int,
    );
  }

}
