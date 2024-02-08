import 'package:edna/app_mode.dart' show EdnaAppMode;
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
  final _events = List<PlayerJournalEventRecord>.empty(growable: true);

  _PlayerJournalEventRecordLogWidgetState(final PlayerJournalEventRecordSource eventSource): _eventSource = eventSource;

  var _maxEvents = 16;
  set maxEvents(final int maxEvents) {
    setState(() {
      _maxEvents = maxEvents;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder<PlayerJournalEventRecord>(
        initialData: null,
        stream: _eventSource.stream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _events.add(snapshot.requireData);
            if (_events.length == _maxEvents) {
              _events.removeRange(0, _events.length - _maxEvents);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index) {
                final record = _events[index];
                return Container(
                  height: 50,
                  child: Center(child: Text('${record.timestamp} - ${record.event}')),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          } else if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error}');
          }
          return const Text('Loading ...');
        });
  }
}
