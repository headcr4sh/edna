// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'E.D.N.A.';

  @override
  String get appName => 'Elite Dangerous Navigation Assistant';

  @override
  String get appModeServerTitle => 'Server';

  @override
  String get appModeClientTitle => 'Client';

  @override
  String get appModeDummyTitle => 'Dummy (non-functional)';
}
