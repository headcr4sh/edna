import 'package:nsd/nsd.dart' as nsd;
import 'package:flutter/material.dart' show ChangeNotifier, WidgetsFlutterBinding;

const _serviceType = '_grpc._tcp';
const _serviceName = 'Elite Dangerous Navigation Assistant (E.D.N.A.)';

abstract class ZeroconfManager extends ChangeNotifier {

  static ZeroconfManager? _instance;

  static Future<ZeroconfManager> get({String? host, int? port}) async {
    WidgetsFlutterBinding.ensureInitialized();
    final discovery = await nsd.startDiscovery(_serviceType);
    if (port != null) {
        final registration = await nsd.register(nsd.Service(
          name: _serviceName,
          type: _serviceName,
          host: host,
          port: port,
        ));
        _instance = _ServerZeroconfManager(discovery, registration);
    } else {
      _instance = _ClientZeroconfManager(discovery);
    }
    return _instance!;
  }

  Set<nsd.Service> get services;

  Future<void> close();

}

class _ClientZeroconfManager extends ZeroconfManager {

  final nsd.Discovery _discovery;
  final Set<nsd.Service> _services = {};

  @override
  Set<nsd.Service> get services => _services;

  _ClientZeroconfManager(final nsd.Discovery discovery):
      _discovery = discovery {
    _discovery.addServiceListener((service, status) {
      if (service.type == _serviceType && service.name == _serviceName) {
        switch (status) {
          case nsd.ServiceStatus.found:
            _services.add(service);
            break;
          case nsd.ServiceStatus.lost:
            _services.remove(service);
            break;
          default:
            // Ignore this case, as it should not happen and if it does, it
            // is most likely not relevant or can't be handled.
            return;
        }
        notifyListeners();
      }
    });
  }


  @override
  Future<void> close() async {
    await nsd.stopDiscovery(_discovery);
  }

}

class _ServerZeroconfManager extends _ClientZeroconfManager {
  final nsd.Registration _registration;
  _ServerZeroconfManager(super.discovery, final nsd.Registration registration):
      _registration = registration;

  @override
  Future<void> close() async {
    await Future.wait([
      super.close(),
      nsd.unregister(_registration)
    ]);
  }

}
