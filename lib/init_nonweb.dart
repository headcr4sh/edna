import './network/network.dart' show MdnsManager;

/// Initialization routines if *not* running in a browser
void configureApp() {
  MdnsManager.initialize();
}
