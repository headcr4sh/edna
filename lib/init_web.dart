import 'package:flutter_web_plugins/flutter_web_plugins.dart' show PathUrlStrategy, setUrlStrategy;

/// Initialization routine if running in a browser.
void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}
