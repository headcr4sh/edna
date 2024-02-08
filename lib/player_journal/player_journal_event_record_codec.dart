import 'dart:convert' show Codec, Converter, StringConversionSinkBase;

import './player_journal_event_record.dart' show PlayerJournalEventRecord;

class PlayerJournalEventRecordCodec extends Codec<PlayerJournalEventRecord, String> {
  @override
  Converter<String, PlayerJournalEventRecord> get decoder => PlayerJournalEventRecordDecoder();
  @override
  Converter<PlayerJournalEventRecord, String> get encoder => PlayerJournalEventRecordEncoder();
}

class PlayerJournalEventRecordConversionSink extends StringConversionSinkBase {
  final Sink<PlayerJournalEventRecord> _output;
  PlayerJournalEventRecordConversionSink(this._output);
  @override
  void addSlice(final String chunk, final int start, final int end, final bool isLast) {
    _output.add(PlayerJournalEventRecord.fromString(chunk.substring(start, end)));
  }

  @override
  void close() {
    _output.close();
  }
}

class PlayerJournalEventRecordDecoder extends Converter<String, PlayerJournalEventRecord> {
  @override
  PlayerJournalEventRecord convert(input) => PlayerJournalEventRecord.fromString(input);

  @override
  Sink<String> startChunkedConversion(Sink<PlayerJournalEventRecord> sink) => PlayerJournalEventRecordConversionSink(sink);
}

class PlayerJournalEventRecordEncoder extends Converter<PlayerJournalEventRecord, String> {
  @override
  String convert(PlayerJournalEventRecord input) => input.toString();
}
