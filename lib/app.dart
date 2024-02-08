import 'dart:io';

import 'package:edna/news/news.dart';
import 'package:edna/help/about_page.dart';
import 'package:edna/player_journal/player_journal.dart';
import 'package:edna/settings/settings_page.dart';
import 'package:edna/status/ship_status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

import 'app_settings.dart';
import 'ed_server_status/ed_server_status.dart' show ServerStatus, ServerStatusLabel;

const String title = 'E.D.N.A.';

class EdnaApp extends StatefulWidget {
  EdnaApp({super.key});

  @override
  State<StatefulWidget> createState() => _EdnaAppState();
}

class _EdnaAppState extends State<EdnaApp> {
  final _pages = <String, Widget Function()>{
    'preferences': () => SettingsPage(),
    'ship_status' : () => const ShipStatusPage(),
    'help_about' : () => const AboutPage(),
  };
  String _currentPage = 'ship_status';

  set currentPage(final String page) {
    setState(() => _currentPage = page);
  }

  Locale _locale = Locale(Platform.localeName);
  ThemeMode _themeMode = ThemeMode.system;

  final _overlayController = OverlayPortalController();

  final _serverStatus = ServerStatus()..refresh();
  final PlayerJournal _playerJournal = PlayerJournal();

  late PlayerJournalEventRecordSource _eventRecordSource;

  set eventRecordSource(final PlayerJournalEventRecordSource eventRecordSource) {
    setState(() {
      _eventRecordSource = eventRecordSource;
      _pages['raw_log'] = () => PlayerJournalEventRecordLogWidget(eventSource: _eventRecordSource);
    });
  }

  _EdnaAppState() {
    _eventRecordSource = PlayerJournalEventRecordSource.local();
    _pages['raw_log'] = () => PlayerJournalEventRecordLogWidget(eventSource: _eventRecordSource);
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
            settings.addListener(() {
              setState(() {
                _locale = settings.locale;
                _themeMode = settings.themeMode;
              });
            });

            child = Builder(
                builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.appTitle),
                            Text(
                              AppLocalizations.of(context)!.appName,
                              textScaler: TextScaler.linear(0.6),
                            ),
                          ],
                        ),
                        actions: [
                          OverlayPortal(
                            child: IconButton(
                              icon: const Icon(Icons.account_circle_outlined),
                              tooltip: 'Not logged in' , // TODO: Implement login state
                              onPressed: () {
                                _overlayController.show();
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                              },
                            ),
                            overlayChildBuilder: (context) => Stack(
                              alignment: Alignment.topRight,
                                children: [
                                  ModalBarrier(
                                    onDismiss: () {
                                      _overlayController.hide();
                                    },
                                  ),
                                  Dialog(child: Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(onPressed: _overlayController.hide, icon: Icon(Icons.close), iconSize: 16.0,)
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white, // TODO adjust to theme
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Text('haha'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            controller: _overlayController,
                          ),
                        ],
                      ),
                      body: _pages[_currentPage]!(),
                      drawer: NavigationDrawer(
                          // Important: Remove any padding from the ListView.
                          tilePadding: EdgeInsets.zero,
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
                            ServerStatusLabel(status: _serverStatus),
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
                                currentPage = 'ship_status';
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Preferences'),
                              leading: const Icon(Icons.settings_outlined),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                              },
                            ),
                          ],
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
