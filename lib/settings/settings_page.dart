import 'package:edna/app_settings.dart';
import 'package:edna/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart' show SettingsList, SettingsSection, SettingsTile;

import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

import '../player_journal/player_journal.dart' show PlayerJournal;

class SettingsPage extends StatefulWidget {

  SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> {

    final _settings = EdnaAppSettings();
    final _playerJournal = PlayerJournal();

    @override
    Widget build(final BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('App appearance'),
              tiles: <SettingsTile>[

                SettingsTile(
                  leading: Icon(Icons.language),
                  trailing: DropdownButton<Locale>(
                    value: AppLocalizations.supportedLocales.contains(_settings.locale) ? _settings.locale : AppLocalizations.supportedLocales.first,
                    onChanged: (Locale? newLocale) {
                      setState(() => _settings.locale = newLocale);
                    },
                    items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>((Locale value) => DropdownMenuItem<Locale>(
                      value: value,
                      child: Text(value.languageCode),
                    )).toList(),
                  ),
                  title: Text('Locale'),
                ),
                SettingsTile(
                  leading: Icon(Icons.color_lens),
                  trailing: DropdownButton<ThemeMode>(
                    value: _settings.themeMode,
                    onChanged: (ThemeMode? newThemeMode) {
                      setState(() => _settings.themeMode = newThemeMode);
                    },
                    items: <DropdownMenuItem<ThemeMode>>[
                      DropdownMenuItem<ThemeMode>(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem<ThemeMode>(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem<ThemeMode>(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                  title: Text('Theme'),
                ),
              ],
            ),
            SettingsSection(
                title: Text('App behavior'),
                tiles: [
              SettingsTile(
                leading: Icon(Icons.cloud_circle),
                trailing: DropdownButton<EdnaAppMode>(
                  value: _settings.mode,
                  onChanged: (EdnaAppMode? newMode) {
                    setState(() => _settings.mode = newMode!);
                  },
                  items: EdnaAppMode.values.map<DropdownMenuItem<EdnaAppMode>>((EdnaAppMode value) => DropdownMenuItem<EdnaAppMode>(
                    value: value,
                    child: Text(value.displayName(context)),
                  )).toList(),
                ),
                title: Text('Mode'),
                description: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_playerJournal.status.online ? Icons.check_box_outlined : Icons.offline_bolt_outlined, size: 16.0,),
                    Text(_playerJournal.status.online ? 'Online' : 'Offline', style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
            ])
          ],
        ),
      );
    }

}
