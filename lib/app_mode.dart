import 'dart:io' show Platform;

import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

bool _currentPlatformIsDesktop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

/// Mode of a currently running E.D.N.A. instance.
/// There must be exactly *one* server-mode instance to which multiple
/// client-mode instances can connect to.
enum EdnaAppMode {
  /// Instance is running on the machine where Elite Dangerous is being played.
  /// Thus: access to the player journal must be a given thing.
  server,

  /// No direct access to the player journal on the local file system is
  /// possible. Connection to a server instance which has access is necessary
  /// to use E.D.N.A. in this mode.
  client,

  /// Dummy mode for tests, development and demonstration purposes.
  dummy;

  /// Default mode to run in if nothing else has been specified. If the current platform is
  /// a desktop platform, the default is server mode. Otherwise, it's client mode.
  static EdnaAppMode defaultForCurrentPlatform() => _currentPlatformIsDesktop() ? EdnaAppMode.server : EdnaAppMode.client;

  static EdnaAppMode fromString(final String? mode) => EdnaAppMode.values.asNameMap()[mode] ?? EdnaAppMode.defaultForCurrentPlatform();

  String displayName(final BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EdnaAppMode.server:
        return l10n.appModeServerTitle;
      case EdnaAppMode.client:
        return l10n.appModeClientTitle;
      case EdnaAppMode.dummy:
        return l10n.appModeDummyTitle;
    }
  }
}
