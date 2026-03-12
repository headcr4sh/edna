import 'dart:io' show Platform;

import 'package:edna/app_mode.dart' show EdnaAppMode;
import 'package:flutter/material.dart' show ChangeNotifier, Locale, ThemeMode;
import 'package:logger/logger.dart' show Logger;
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

const _appThemeKey = 'app.theme';
const _appLocaleKey = 'app.locale';
const _appModeKey = 'app.mode';
const _appJournalDirOverrideKey = 'app.journalDirOverride';
const _appServerHostKey = 'app.serverHost';
const _appServerPortKey = 'app.serverPort';

class EdnaAppSettings with ChangeNotifier {
  static final EdnaAppSettings _instance = EdnaAppSettings._internal();

  factory EdnaAppSettings() => _instance;

  late SharedPreferences _preferences;
  bool _isInitialized = false;

  Future<EdnaAppSettings> initialize(
      {final SharedPreferences? preferences}) async {
    if (preferences != null) {
      _preferences = preferences;
    } else {
      _preferences = await SharedPreferences.getInstance();
    }
    _isInitialized = true;
    notifyListeners();
    return this;
  }

  EdnaAppMode get mode => _isInitialized
      ? (EdnaAppMode.values.asNameMap()[_preferences.getString(_appModeKey)] ??
          EdnaAppMode.defaultForCurrentPlatform())
      : EdnaAppMode.defaultForCurrentPlatform();
  set mode(final EdnaAppMode mode) {
    _preferences
        .setString(_appModeKey, mode.name)
        .then((_) => notifyListeners(), onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  set locale(final Locale? locale) {
    Future<bool> f;
    if (locale == null) {
      f = _preferences.remove(_appLocaleKey);
    } else {
      f = _preferences.setString(_appLocaleKey, locale.languageCode);
    }
    f.then((_) {
      notifyListeners();
      return true;
    }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  Locale get locale {
    final languageCode =
        _isInitialized ? _preferences.getString(_appLocaleKey) : null;
    return languageCode == null
        ? Locale(Platform.localeName)
        : Locale.fromSubtags(languageCode: languageCode);
  }

  set themeMode(final ThemeMode? themeMode) {
    Future<bool> f;
    if (themeMode == null) {
      f = _preferences.remove(_appThemeKey);
    } else {
      f = _preferences.setString(_appThemeKey, themeMode.name);
    }
    f.then((_) {
      notifyListeners();
      return true;
    }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  ThemeMode get themeMode => _isInitialized
      ? (ThemeMode.values.asNameMap()[_preferences.getString(_appThemeKey)] ??
          ThemeMode.system)
      : ThemeMode.system;

  String? get journalDirOverride =>
      _isInitialized ? _preferences.getString(_appJournalDirOverrideKey) : null;

  set journalDirOverride(final String? path) {
    Future<bool> f;
    if (path == null || path.isEmpty) {
      f = _preferences.remove(_appJournalDirOverrideKey);
    } else {
      f = _preferences.setString(_appJournalDirOverrideKey, path);
    }
    f.then((_) {
      notifyListeners();
      return true;
    }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  String? get serverHost =>
      _isInitialized ? _preferences.getString(_appServerHostKey) : null;

  set serverHost(final String? host) {
    Future<bool> f;
    if (host == null || host.isEmpty) {
      f = _preferences.remove(_appServerHostKey);
    } else {
      f = _preferences.setString(_appServerHostKey, host);
    }
    f.then((_) {
      notifyListeners();
      return true;
    }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  int? get serverPort =>
      _isInitialized ? _preferences.getInt(_appServerPortKey) : null;

  set serverPort(final int? port) {
    Future<bool> f;
    if (port == null) {
      f = _preferences.remove(_appServerPortKey);
    } else {
      f = _preferences.setInt(_appServerPortKey, port);
    }
    f.then((_) {
      notifyListeners();
      return true;
    }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  EdnaAppSettings._internal();
}
