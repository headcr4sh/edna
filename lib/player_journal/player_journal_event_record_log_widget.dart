
import 'dart:async' show StreamSubscription;
import 'dart:convert' show JsonEncoder;
import 'package:flutter/material.dart';
import 'player_journal.dart' show PlayerJournalEventRecord, PlayerJournalEventRecordSource;

class PlayerJournalEventRecordLogWidget extends StatefulWidget {

  /// Event source to be used for displaying events.
  final PlayerJournalEventRecordSource _eventSource;

  PlayerJournalEventRecordLogWidget({super.key, required PlayerJournalEventRecordSource eventSource }) : _eventSource = eventSource;

  @override
  State<PlayerJournalEventRecordLogWidget> createState() => _PlayerJournalEventRecordLogWidgetState(_eventSource);

}

class _PlayerJournalEventRecordLogWidgetState extends State<PlayerJournalEventRecordLogWidget> {
  final PlayerJournalEventRecordSource _eventSource;
  final List<PlayerJournalEventRecord> _events = [];
  late final StreamSubscription<PlayerJournalEventRecord> _subscription;

  _PlayerJournalEventRecordLogWidgetState(this._eventSource);

  var _maxEvents = 1024;
  set maxEvents(final int maxEvents) {
    setState(() {
      _maxEvents = maxEvents;
      if (_events.length > _maxEvents) {
        _events.removeRange(0, _events.length - _maxEvents);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _subscription = _eventSource.stream().listen((record) {
      setState(() {
        _events.add(record);
        if (_events.length > _maxEvents) {
          int overflow = _events.length - _maxEvents;
          _events.removeRange(0, overflow);
        }
      });
    }, onError: (error) {
      debugPrint('Error in PlayerJournal log stream: $error');
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_events.isEmpty) {
      return const Center(child: Text('Loading or waiting for events...'));
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _events.length,
      itemBuilder: (BuildContext context, int index) {
        // Reverse order, newest at the top
        final record = _events[_events.length - 1 - index];
        final prettyJson = const JsonEncoder.withIndent('  ').convert(record.rawJson);
        return ExpansionTile(
          title: Text('${record.timestamp} - ${record.event}'),
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: SelectableText(prettyJson, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
