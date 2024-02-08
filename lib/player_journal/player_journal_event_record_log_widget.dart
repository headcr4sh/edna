import 'package:edna/app_mode.dart' show EdnaAppMode;
import 'package:flutter/material.dart';
import 'player_journal.dart' show PlayerJournalEventRecord, PlayerJournalEventRecordSource;

class PlayerJournalEventRecordLogWidget extends StatefulWidget {

  /// Event source to be used for displaying events.
  final PlayerJournalEventRecordSource _eventSource;

  PlayerJournalEventRecordLogWidget({super.key, required PlayerJournalEventRecordSource eventSource }) : _eventSource = eventSource;

  factory PlayerJournalEventRecordLogWidget.server({Key? key}) => PlayerJournalEventRecordLogWidget(key: key, eventSource: PlayerJournalEventRecordSource.local());
  factory PlayerJournalEventRecordLogWidget.dummy({Key? key}) => PlayerJournalEventRecordLogWidget(key: key, eventSource: PlayerJournalEventRecordSource.dummy());

  factory PlayerJournalEventRecordLogWidget.forMode({Key? key, required EdnaAppMode mode }) {
    switch (mode) {
      case EdnaAppMode.server:
        return PlayerJournalEventRecordLogWidget.server(key: key);
      case EdnaAppMode.client:
        throw UnsupportedError('Not yet implemented');
      case EdnaAppMode.dummy:
        return PlayerJournalEventRecordLogWidget.dummy(key: key);
      default:
        throw Exception('Unsupported app mode: ${mode.toString()}');
    }
  }

  @override
  State<PlayerJournalEventRecordLogWidget> createState() => _PlayerJournalEventRecordLogWidgetState(_eventSource);

}

class _PlayerJournalEventRecordLogWidgetState extends State<PlayerJournalEventRecordLogWidget> {
  final PlayerJournalEventRecordSource _eventSource;
  final List<PlayerJournalEventRecord> _events = [];

  _PlayerJournalEventRecordLogWidgetState(final PlayerJournalEventRecordSource eventSource): _eventSource = eventSource;

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder<PlayerJournalEventRecord>(
        initialData: null,
        stream: _eventSource.stream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _events.insert(0, snapshot.requireData);
            if (_events.length > 128) {
              _events.removeRange(127, _events.length);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Center(child: Text('${_events[index].timestamp} - ${_events[index].event}')),
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
