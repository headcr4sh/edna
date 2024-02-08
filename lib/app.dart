import 'dart:io';

import 'package:edna/player_journal/player_journal.dart';
import 'package:edna/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

import 'app_mode.dart';
import 'app_settings.dart';

const String title = 'E.D.N.A.';

class EdnaApp extends StatefulWidget {
  EdnaApp({super.key});

  @override
  State<StatefulWidget> createState() => _EdnaAppState();
}

class _EdnaAppState extends State<EdnaApp> {

  final _pages = <String, Widget Function()>{};
  var _currentPage = 'raw_log';

  set currentPage(final String page) {
    setState(() => _currentPage = page);
  }

  Locale _locale = Locale(Platform.localeName);
  ThemeMode _themeMode = ThemeMode.system;
  EdnaAppMode _mode = EdnaAppMode.defaultForCurrentPlatform();

  _EdnaAppState() {
    _pages['raw_log'] = () => PlayerJournalEventRecordLogWidget(eventSource: PlayerJournalEventRecordSource.local());
  }

  @override
  Widget build(final BuildContext context) => FutureBuilder<EdnaAppSettings>(
    future: EdnaAppSettings().initialize(),
    builder: (final BuildContext context, final AsyncSnapshot<EdnaAppSettings> snapshot) {
      Widget child;
      if (snapshot.hasData) {
        final settings = snapshot.requireData;
        _locale = settings.locale;
        _themeMode = settings.themeMode;
        _mode = settings.mode;
        settings.addListener(() {
          setState(() {
            _locale = settings.locale;
            _themeMode = settings.themeMode;
            _mode = settings.mode;
          });
        });
        child = Builder(builder: (context) => Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  AppLocalizations.of(context)!.appName,
                  textScaler: TextScaler.linear(0.6),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Preferences',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ],
          ),
          body: _pages[_currentPage]!(),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 2.0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepOrange,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/icons/ed_logo_clean.png"),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Event Log'),
                  subtitle: const Text('View the raw event log stream'),
                  leading: const Icon(Icons.bug_report_outlined),
                  onTap: () {
                    currentPage = 'raw_log';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Ship Status'),
                  subtitle: const Text('<Ship_name>'),
                  leading: const Icon(Icons.dashboard_outlined),
                  onTap: () {
                    // TODO Update the state of the app.
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
      } else if (snapshot.hasError) {
        child = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(snapshot.error.toString()),
            ),
          ],
        );

      } else {
        child = SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(),
        );
      }
      return MaterialApp(
        title: title,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.orange,
        ),
        themeMode: _themeMode,
        home: child,
      );
    },
  );

}
