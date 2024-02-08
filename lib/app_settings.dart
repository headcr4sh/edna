import 'dart:io' show Platform;

import 'package:edna/app_mode.dart' show EdnaAppMode;
import 'package:flutter/material.dart' show ChangeNotifier, Locale, ThemeMode;
import 'package:logger/logger.dart' show Logger;
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

const _appThemeKey = 'app.theme';
const _appLocaleKey = 'app.locale';
const _appModeKey = 'app.mode';


class EdnaAppSettings with ChangeNotifier {

  static final EdnaAppSettings _instance = EdnaAppSettings._internal();

  factory EdnaAppSettings() => _instance;

  late SharedPreferences _preferences;

  Future<EdnaAppSettings> initialize ({final SharedPreferences? preferences}) async {
    if (preferences != null) {
      _preferences = preferences;
    } else {
      _preferences = await SharedPreferences.getInstance();
    }
    notifyListeners();
    return this;
  }

  EdnaAppMode get mode => EdnaAppMode.values.asNameMap()[_preferences.getString(_appModeKey)] ?? EdnaAppMode.defaultForCurrentPlatform();
  set mode(final EdnaAppMode mode) {
    _preferences.setString(_appModeKey, mode.name).then((_) => notifyListeners(), onError: (error, stackTrace) {
      logger.e('Error while saving settings.', error: error, stackTrace: stackTrace is StackTrace ? stackTrace : null);
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
    f.then((_) {notifyListeners(); return true; }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.', error: error, stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  Locale get locale {
    final languageCode = _preferences.getString(_appLocaleKey);
    return languageCode == null ? Locale(Platform.localeName) : Locale.fromSubtags(languageCode: languageCode);
  }

  set themeMode(final ThemeMode? themeMode) {
    Future<bool> f;
    if (themeMode == null) {
      f = _preferences.remove(_appThemeKey);
    } else {
      f = _preferences.setString(_appThemeKey, themeMode.name);
    }
    f.then((_) {notifyListeners(); return true; }, onError: (error, stackTrace) {
      logger.e('Error while saving settings.', error: error, stackTrace: stackTrace is StackTrace ? stackTrace : null);
      return false;
    });
  }

  ThemeMode get themeMode => ThemeMode.values.asNameMap()[_preferences.getString(_appThemeKey)] ?? ThemeMode.system;

  EdnaAppSettings._internal();

}
