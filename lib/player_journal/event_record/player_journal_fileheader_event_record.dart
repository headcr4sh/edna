import 'package:edna/player_journal/player_journal.dart';

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
