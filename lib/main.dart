import 'package:flutter/material.dart';

import 'dart:developer' as dev;

import './init_nonweb.dart' if (dart.library.html) 'init_web.dart' show configureApp;
import './app.dart' show EdnaApp;

void main(final List<String> args) {
  dev.log('Performing platform-specific pre-launch configuration', name: 'main');
  configureApp();
  dev.log('Starting E.D.N.A. app', name: 'main');
  runApp(EdnaApp());
}
