import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'package:win32/win32.dart' as win32;

const supported = true;

Future<void> pressKey(final int keyCode) async {
  final kbd = calloc<win32.INPUT>();
  kbd.ref.type = win32.INPUT_TYPE.INPUT_KEYBOARD;
  kbd.ref.ki.wVk = keyCode;
  var result = win32.SendInput(1, kbd, sizeOf<win32.INPUT>());
  if (result != win32.TRUE) {
    throw ('Error: ${win32.GetLastError()}');
  }
}

