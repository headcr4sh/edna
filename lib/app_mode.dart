import 'dart:io' show Platform;

/// Mode of a currently running E.D.N.A. instance.
/// There must be exactly *one* server-mode instance to which multiple
/// client-mode instances can connect to.
enum EdnaAppMode {
  /// Default mode, which will be determined automatically by analyzing the
  /// platform we are running on and possibly some other factors.s
  auto,

  /// Instance is running on the machine where Elite Dangerous is being played.
  /// Thus: access to the player journal must be a given thing.
  server,

  /// No direct access to the player journal on the local file system is
  /// possible. Connection to a server instance which has access is necessary
  /// to use E.D.N.A. in this mode.
  client,

  /// Dummy mode for tests, development and demonstration purposes.
  dummy,
}

final EdnaAppMode defaultAppMode = Platform.isWindows ? EdnaAppMode.server : EdnaAppMode.client;
