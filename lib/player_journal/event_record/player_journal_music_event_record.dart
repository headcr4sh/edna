import 'package:edna/player_journal/player_journal.dart';

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
