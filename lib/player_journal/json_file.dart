import 'dart:async' show StreamSubscription;
import 'dart:convert' show jsonDecode;
import 'dart:developer' as dev;
import 'dart:io' show File, FileSystemModifyEvent, FileSystemEvent, Platform;
import 'package:async/async.dart' show StreamGroup;
import 'package:flutter/material.dart' show ChangeNotifier;

class JsonFile<M> with ChangeNotifier {
  final File _file;
  M? _model;
  late StreamSubscription<FileSystemEvent> _subscription;

  M? get model => _model;

  JsonFile({required final File file, required M Function(Map<String, dynamic>) decoder}) : _file = file {
    // Initial event, because the file might already contain data which
    // we want to consume before the file is being replaced.
    final initialEvent = FileSystemModifyEvent(_file.path, false, true);
    final events = StreamGroup.merge([
      Stream.value(initialEvent),
      Platform.isWindows ? _file.parent.watch(events: FileSystemEvent.all)
                         : _file.watch(events: FileSystemEvent.all),
    ]);
    dev.log('Watching file: "${_file.path}"', name: 'JsonFile');
    _subscription = events.listen(
        (data) {
          if (data.path != _file.path) {
            return;
          }
          if ([FileSystemEvent.create, FileSystemEvent.modify].contains(data.type)) {
            try {
              _model = decoder(jsonDecode(_file.readAsStringSync()) as Map<String, dynamic>);
            } catch (e) {
              _model = null;
              // File might does not (yet?) exist. That's o.k., though.
              if (data != initialEvent) {
                rethrow;
              }
            } finally {
              notifyListeners();
            }
          }
        },
        // TODO implement error handling by implementing onError
        cancelOnError: true,
    );
    _subscription.resume();
  }

  void close() {
    _subscription.cancel();
    _model = null;
  }

  @override
  String toString() => _file.absolute.path;

}
