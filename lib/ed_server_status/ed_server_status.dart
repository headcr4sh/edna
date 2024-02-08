library edna.ed_server_status;

export './status_label.dart';

import 'dart:convert' show jsonDecode;
import 'dart:developer' as dev;
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:http/http.dart' as http;

const url = 'https://ed-server-status.orerve.net/';

class ServerStatus with ChangeNotifier{
  String? _status;
  String? _message;
  int? _code;
  String? _product;

  String? get status => _status;

  bool get isUnknown => _status == null;
  bool get isGood => _status == 'Good';
  bool get isMaintenance => _status == 'Maintenance';

  bool get hasMessage => _message != null && _message!.isNotEmpty;
  String get message => _message ?? '';

  int? get code => _code;
  String? get product => _product;

  DateTime? _lastRefreshed;
  DateTime? get lastRefreshed => _lastRefreshed;

  Future<http.Response>? _refreshResponse;
  bool get isRefreshing => _refreshResponse != null;

  ServerStatus({String? status, String? message, int? code, String? product})
      : _status = status,
        _message = message,
        _code = code,
        _product = product;

  ServerStatus.fromJson(Map<String, dynamic> json) {
    _status = json['status'] as String;
    _message = json['message'] as String;
    _code = json['code'] as int;
    _product = json['product'] as String;
  }

  @override
  int get hashCode => _status.hashCode ^ _message.hashCode ^ _code.hashCode ^ _product.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ServerStatus && runtimeType == other.runtimeType && (
              _status == other._status
           && _message == other._message
           && _code == other._code
           && _product == other._product)
          );

  void refresh({ String url = url }) async {
    dev.log('Refresh of server status requested', name: 'ServerStatus');
    if (_refreshResponse != null) {
      return;
    }

    ServerStatus newStatus = ServerStatus(status: 'Unknown', message: 'Refreshing...');
    try {
      _refreshResponse = http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
      final response = await _refreshResponse;
      if (response!.statusCode == 200) {
        newStatus = ServerStatus.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        newStatus._message = 'Server returned status code ${response.statusCode}';
      }
    } on Exception catch (e) {
      newStatus._message = e.toString();
    } finally {
      _refreshResponse = null;
    }

    _lastRefreshed = DateTime.now();

    if (this != newStatus) {
      _status = newStatus._status;
      _message = newStatus._message;
      _code = newStatus._code;
      _product = newStatus._product;
      notifyListeners();
    }

    dev.log('E:D Server status has changed: "$_status"${_message != null ? " $_message" : ""}', name: 'ServerStatus');
    notifyListeners();
  }

}
