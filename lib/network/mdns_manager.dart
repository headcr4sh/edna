import 'dart:async';
import 'dart:io';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';

const String _serviceType = '_edna._tcp';

class MdnsService {
  final String name;
  final String host;
  final int port;

  MdnsService({required this.name, required this.host, required this.port});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MdnsService &&
          runtimeType == other.runtimeType &&
          host == other.host &&
          port == other.port;

  @override
  int get hashCode => host.hashCode ^ port.hashCode;
}

abstract class MdnsManager extends ChangeNotifier {
  static MdnsManager? _instance;

  static MdnsManager get instance {
    return _instance ??= _BonsoirMdnsManager();
  }

  static Future<void> initialize() async {
    instance;
  }

  static Future<MdnsManager> get({int? port}) async {
    final manager = instance;
    if (port != null) {
      manager.startAnnouncing(port);
    }
    return manager;
  }

  Set<MdnsService> get services;
  void startAnnouncing(int port);
  Future<void> stop();
}

class _BonsoirMdnsManager extends MdnsManager {
  final Set<MdnsService> _services = {};
  BonsoirDiscovery? _discovery;
  BonsoirBroadcast? _broadcast;

  @override
  Set<MdnsService> get services => _services;

  _BonsoirMdnsManager() {
    _initDiscovery();
  }

  Future<void> _initDiscovery() async {
    _discovery = BonsoirDiscovery(type: _serviceType);
    await _discovery!.initialize();
    _discovery!.eventStream!.listen((event) {
      if (event is BonsoirDiscoveryServiceResolvedEvent) {
        final service = event.service;
        final host = service.host;
        if (host != null) {
          final mdnsService = MdnsService(
            name: service.name,
            host: host,
            port: service.port,
          );
          if (!_services.contains(mdnsService)) {
            _services.add(mdnsService);
            notifyListeners();
          }
        }
      } else if (event is BonsoirDiscoveryServiceFoundEvent) {
        event.service.resolve(_discovery!.serviceResolver);
      } else if (event is BonsoirDiscoveryServiceLostEvent) {
        _services.removeWhere((s) => s.name == event.service.name);
        notifyListeners();
      }
    });
    await _discovery!.start();
  }

  @override
  void startAnnouncing(int port) async {
    if (_broadcast != null) {
      await _broadcast!.stop();
    }

    final service = BonsoirService(
      name: 'E.D.N.A. on ${Platform.localHostname}',
      type: _serviceType,
      port: port,
    );

    _broadcast = BonsoirBroadcast(service: service);
    await _broadcast!.initialize();
    await _broadcast!.start();
  }

  @override
  Future<void> stop() async {
    await _discovery?.stop();
    await _broadcast?.stop();
    _discovery = null;
    _broadcast = null;
  }
}
