import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:edna/player_journal/player_journal.dart';

class SessionStorage with ChangeNotifier {
  static final SessionStorage _instance = SessionStorage._internal();

  factory SessionStorage() => _instance;

  PlayerJournalStatisticsEventRecord? statistics;
  PlayerJournalProgressEventRecord? progress;
  PlayerJournalRankEventRecord? rank;
  PlayerJournalBackpackMaterialsEventRecord? materials;
  StreamSubscription<PlayerJournalEventRecord>? _subscription;

  SessionStorage._internal();

  void listenTo(PlayerJournalEventRecordSource source) {
    _subscription?.cancel();
    _subscription = source.stream().listen(_onEvent, onError: (error) {
      debugPrint('Error in SessionStorage stream: $error');
    });
  }

  void _onEvent(PlayerJournalEventRecord event) {
    bool updated = false;

    if (event is PlayerJournalStatisticsEventRecord) {
      statistics = event;
      updated = true;
    } else if (event is PlayerJournalProgressEventRecord) {
      progress = event;
      updated = true;
    } else if (event is PlayerJournalRankEventRecord) {
      rank = event;
      updated = true;
    } else if (event is PlayerJournalBackpackMaterialsEventRecord) {
      materials = event;
      updated = true;
    }

    if (updated) {
      notifyListeners();
    }
  }
  void clear() {
    statistics = null;
    progress = null;
    rank = null;
    materials = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
