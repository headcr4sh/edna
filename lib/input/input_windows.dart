import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'package:win32/win32.dart' as win32;

const supported = true;

Future<void> pressKey(final String key) async {
  // Simple check if it's already a number string
  final keyCode = int.tryParse(key) ?? 0;
  if (keyCode == 0) return;

  final kbd = calloc<win32.INPUT>();
  kbd.ref.type = win32.INPUT_KEYBOARD;
  // In win32 6.x, wVk might be a VIRTUAL_KEY type or int. 
  // We'll try to cast to dynamic to bypass strong typing if it's a wrapper class.
  (kbd.ref.ki as dynamic).wVk = keyCode;
  final result = win32.SendInput(1, kbd, sizeOf<win32.INPUT>());
  if (result == 0) {
    throw ('Error: ${win32.GetLastError()}');
  }
}

