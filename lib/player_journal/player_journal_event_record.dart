import 'dart:convert';

import 'package:edna/player_journal/player_journal.dart';

import './player_journal_event_type.dart' show PlayerJournalEventType;

abstract class PlayerJournalEventRecord {

  final DateTime _timestamp;
  DateTime get timestamp => _timestamp;

  final PlayerJournalEventType _event;
  PlayerJournalEventType get event => _event;

  PlayerJournalEventRecord({ required final DateTime timestamp, required final PlayerJournalEventType event }): _timestamp = timestamp, _event = event;
  factory PlayerJournalEventRecord.fromJson(final Map<String, dynamic> json) {
    final timestamp = DateTime.parse(json['timestamp'] as String);
    final PlayerJournalEventType event = json['event'] as String;
    switch (event) {
      case PlayerJournalCommanderEventRecord.type:
        final String fid = json['FID'] as String;
        final String name = json['Name'] as String;
        return PlayerJournalCommanderEventRecord(timestamp: timestamp, fid: fid, name: name);
      case PlayerJournalContinuedEventRecord.type:
        final part = json['Part'] as int;
        return PlayerJournalContinuedEventRecord(timestamp: timestamp, part: part);
      case PlayerJournalFileheaderEventRecord.type:
        final part = json['part'] as int;
        final String language = json['language'] as String;
        final String gameVersion = json['gameversion'] as String;
        final String build = json['build'].trim() as String;
        return PlayerJournalFileheaderEventRecord(timestamp: timestamp, part: part, language: language, gameVersion: gameVersion, build: build);
      case PlayerJournalMusicEventRecord.type:
        final musicTrack = json['MusicTrack'] as String;
        return PlayerJournalMusicEventRecord(timestamp: timestamp, musicTrack: musicTrack);
      case PlayerJournalRankEventRecord.type:
        final combat = json['Combat'] as int;
        final trade = json['Trade'] as int;
        final explore = json['Explore'] as int;
        final empire = json['Empire'] as int;
        final federation = json['Federation'] as int;
        final cqc = json['CQC'] as int;
        return PlayerJournalRankEventRecord(timestamp: timestamp, combat: combat, trade: trade, explore: explore, empire: empire, federation: federation, cqc: cqc);
      case PlayerJournalProgressEventRecord.type:
        final combat = json['Combat'] as int;
        final trade = json['Trade'] as int;
        final explore = json['Explore'] as int;
        final empire = json['Empire'] as int;
        final federation = json['Federation'] as int;
        final cqc = json['CQC'] as int;
        return PlayerJournalProgressEventRecord(timestamp: timestamp, combat: combat, trade: trade, explore: explore, empire: empire, federation: federation, cqc: cqc);
      case PlayerJournalShutdownEventRecord.type:
        return PlayerJournalShutdownEventRecord(timestamp: timestamp);
      default:
        return PlayerJournalUnknownEventRecord(timestamp: timestamp, event: event);
    }
  }
  factory PlayerJournalEventRecord.fromString(final String jsonString) => PlayerJournalEventRecord.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  @override
  String toString() {
    return '[${timestamp.toIso8601String()}] $event';
  }
}

class PlayerJournalCommanderEventRecord extends PlayerJournalEventRecord {

  static const type = 'Commander';

  final String _fid;
  String get fid => _fid;

  final String _name;
  String get name => _name;

  PlayerJournalCommanderEventRecord({
    required super.timestamp,
    required final String fid,
    required final String name,
  })
  : _fid = fid,
    _name = name,
    super(event: PlayerJournalCommanderEventRecord.type);
}

class PlayerJournalContinuedEventRecord extends PlayerJournalEventRecord {

  static const type = 'Continued';

  final int _part;
  int get part => _part;

  PlayerJournalContinuedEventRecord({
    required super.timestamp,
    required final int part,
  })
      : _part = part,
        super(event: PlayerJournalContinuedEventRecord.type);
}

class PlayerJournalFileheaderEventRecord extends PlayerJournalEventRecord {

  static const type = 'Fileheader';

  final int _part;
  int get part => _part;

  final String _language;
  String get language => _language;

  final String _gameVersion;
  String get gameVersion => _gameVersion;

  final String _build;
  String get build => _build;

  PlayerJournalFileheaderEventRecord({
    required super.timestamp,
    required final int part,
    required final String language,
    required final String gameVersion,
    required final String build,
  })
  : _part = part,
    _language = language,
    _gameVersion = gameVersion,
    _build = build,
    super(event: PlayerJournalFileheaderEventRecord.type);
}

class PlayerJournalMusicEventRecord extends PlayerJournalEventRecord {
  static const type = 'Music';

  final String _musicTrack;
  String get musicTrack => _musicTrack;

  PlayerJournalMusicEventRecord({
    required super.timestamp,
    required final String musicTrack,
  })
  : _musicTrack = musicTrack,
    super(event: PlayerJournalMusicEventRecord.type);
}

class PlayerJournalRankEventRecord extends PlayerJournalEventRecord {
  static const type = 'Rank';

  final int _combat;
  int get combat => _combat;

  final int _trade;
  int get trade => _trade;

  final int _explore;
  int get explore => _explore;

  final int _empire;
  int get empire => _empire;

  final int _federation;
  int get federation => _federation;

  final int _cqc;
  int get cqc => _cqc;

  PlayerJournalRankEventRecord({
    required final DateTime timestamp,
    required final int combat,
    required final int trade,
    required final int explore,
    required final int empire,
    required final int federation,
    required final int cqc,
  })
  : _combat = combat,
    _trade = trade,
    _explore = explore,
    _empire = empire,
    _federation = federation,
    _cqc = cqc,
    super(timestamp: timestamp, event: PlayerJournalRankEventRecord.type);
}

class PlayerJournalProgressEventRecord extends PlayerJournalEventRecord {

  final int _combat;
  int get combat => _combat;

  final int _trade;
  int get trade => _trade;

  final int _explore;
  int get explore => _explore;

  final int _empire;
  int get empire => _empire;

  final int _federation;
  int get federation => _federation;

  final int _cqc;
  int get cqc => _cqc;

  static const type = 'Progress';
  PlayerJournalProgressEventRecord({
    required super.timestamp,
    required int combat,
    required int trade,
    required int explore,
    required int empire,
    required int federation,
    required int cqc,
  }):
      _combat = combat,
      _trade = trade,
      _explore = explore,
      _empire = empire,
      _federation = federation,
      _cqc = cqc,
      super(event: PlayerJournalProgressEventRecord.type);
}

class PlayerJournalShutdownEventRecord extends PlayerJournalEventRecord {
  static const type = 'Shutdown';
  PlayerJournalShutdownEventRecord({ required super.timestamp }): super(event: PlayerJournalShutdownEventRecord.type);
}

class PlayerJournalUnknownEventRecord extends PlayerJournalEventRecord {
  PlayerJournalUnknownEventRecord({ required super.timestamp, required super.event });
}
