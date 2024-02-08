import 'package:flutter/material.dart';

import './init_nonweb.dart' if (dart.library.html) 'init_web.dart' show configureApp;
import './app.dart' show EdnaApp;

void main(final List<String> args) {
  configureApp();
  runApp(EdnaApp());
}
