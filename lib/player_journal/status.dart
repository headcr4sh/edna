import 'package:flutter/material.dart';

abstract class Status extends ChangeNotifier {
  DateTime _timestamp = DateTime(1970);
  DateTime get timestamp => _timestamp;

  String _event = "Status";
  String get event => _event;

  int _flags = 0;
  int get flags => _flags;

  Status();
}

class UpdatableStatus extends Status {

  void set({required final DateTime timestamp, required final String event, required final int flags}) {
    _timestamp = timestamp;
    _event = event;
    _flags = flags;
    notifyListeners();
  }

}
