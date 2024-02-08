import './input_unsupported.dart' if (dart.io.Platform.isWindows) './input_windows.dart' as impl;

class KeyEventEmitter {
  static final KeyEventEmitter _instance = KeyEventEmitter._internal();
  factory KeyEventEmitter._() => _instance;
  KeyEventEmitter._internal();

  Future<void> pressKey(final String key) {
    return impl.pressKey(key);
  }

}
