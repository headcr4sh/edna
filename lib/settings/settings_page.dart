import 'package:edna/app_settings.dart';
import 'package:edna/app_mode.dart';
import 'package:edna/network/mdns_manager.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart'
    show SettingsList, SettingsSection, SettingsTile, SettingsThemeData;

import 'package:edna/l10n/app_localizations.dart' show AppLocalizations;

import '../player_journal/player_journal.dart' show PlayerJournal;

class SettingsPage extends StatefulWidget {
  final VoidCallback? onReset;
  const SettingsPage({super.key, this.onReset});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = EdnaAppSettings();
  final _playerJournal = PlayerJournal();

  @override
  Widget build(final BuildContext context) {
    // Determine string names of UI locales to make language more readable.
    String getDisplayLanguage(Locale locale) {
      if (locale.languageCode == 'en') return 'English';
      if (locale.languageCode == 'de') return 'Deutsch';
      return locale.languageCode.toUpperCase();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        centerTitle: true,
      ),
      body: SettingsList(
        // Give it a more modern, slightly lighter look relying on Material3 defaults.
        lightTheme: const SettingsThemeData(
          settingsListBackground: Colors.transparent,
          settingsSectionBackground: Colors.transparent,
          dividerColor: Colors.black12,
        ),
        darkTheme: const SettingsThemeData(
          settingsListBackground: Colors.transparent,
          settingsSectionBackground: Colors.transparent,
          dividerColor: Colors.white10,
        ),
        sections: [
          SettingsSection(
            title: const Text('Appearance'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                description: const Text('Choose the app display language'),
                trailing: DropdownButton<Locale>(
                  underline: const SizedBox.shrink(),
                  value: AppLocalizations.supportedLocales
                          .contains(_settings.locale)
                      ? _settings.locale
                      : null,
                  onChanged: (final Locale? newValue) {
                    if (newValue != null) {
                      setState(() => _settings.locale = newValue);
                    }
                  },
                  items: AppLocalizations.supportedLocales
                      .map<DropdownMenuItem<Locale>>(
                          (final Locale value) => DropdownMenuItem<Locale>(
                                value: value,
                                child: Text(getDisplayLanguage(value)),
                              ))
                      .toList(),
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Theme'),
                description: const Text('Toggle light or dark mode'),
                trailing: DropdownButton<ThemeMode>(
                  underline: const SizedBox.shrink(),
                  value: _settings.themeMode,
                  onChanged: (ThemeMode? newThemeMode) {
                    if (newThemeMode != null) {
                      setState(() => _settings.themeMode = newThemeMode);
                    }
                  },
                  items: const <DropdownMenuItem<ThemeMode>>[
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.system,
                      child: Text('System Defaults',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.light,
                      child: Text('Light',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.dark,
                      child: Text('Dark',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SettingsSection(title: const Text('Behavior'), tiles: [
            SettingsTile(
              leading: const Icon(Icons.settings_suggest_outlined),
              title: const Text('Operation Mode'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<EdnaAppMode>(
                    underline: const SizedBox.shrink(),
                    value: _settings.mode,
                    onChanged: (EdnaAppMode? newMode) {
                      if (newMode != null) {
                        setState(() => _settings.mode = newMode);
                        if (widget.onReset != null) {
                          widget.onReset!();
                        }
                      }
                    },
                    items: EdnaAppMode.values
                        .map<DropdownMenuItem<EdnaAppMode>>(
                            (EdnaAppMode value) =>
                                DropdownMenuItem<EdnaAppMode>(
                                  value: value,
                                  child: Text(value.displayName(context),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ))
                        .toList(),
                  ),
                  if (widget.onReset != null)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset and restart event source',
                      onPressed: widget.onReset,
                    ),
                ],
              ),
            ),
            if (_settings.mode == EdnaAppMode.client)
              SettingsTile(
                leading: const Icon(Icons.wifi_find_outlined),
                title: const Text('E.D.N.A Server Selection'),
                value: Text(_settings.serverHost != null ? '${_settings.serverHost}:${_settings.serverPort}' : 'Tap to scan and configure'),
                onPressed: (context) {
                   showDialog(context: context, builder: (context) {
                      return ListenableBuilder(
                         listenable: MdnsManager.instance,
                         builder: (context, _) {
                            final services = MdnsManager.instance.services.toList();
                            return AlertDialog(
                                title: const Text('Discovered Servers'),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Text('Select an E.D.N.A. server found on your local network:'),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                            width: double.maxFinite,
                                            height: 300,
                                            child: services.isEmpty ? const Center(child: Text('No servers discovered yet.')) : ListView.builder(
                                                itemCount: services.length,
                                                itemBuilder: (context, index) {
                                                    final svc = services[index];
                                                    return ListTile(
                                                        leading: const Icon(Icons.dns_outlined),
                                                        title: Text(svc.name),
                                                        subtitle: Text('${svc.host}:${svc.port}'),
                                                        onTap: () {
                                                            setState(() {
                                                                _settings.serverHost = svc.host;
                                                                _settings.serverPort = svc.port;
                                                            });
                                                            if (widget.onReset != null) widget.onReset!();
                                                            Navigator.pop(context);
                                                        }
                                                    );
                                                }
                                            )
                                        ),
                                    ],
                                ),
                                actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                                ]
                            );
                         }
                      );
                   });
                }
              ),
            SettingsTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('Player Journal Location'),
              value: Text(
                _settings.journalDirOverride?.isNotEmpty == true
                    ? _settings.journalDirOverride!
                    : PlayerJournal.localJournalPath()?.path ?? 'Not found',
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: (context) async {
                final textController = TextEditingController(
                  text: _settings.journalDirOverride ?? '',
                );
                final newPath = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Override Journal Directory'),
                    content: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Leave empty for defaults',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(textController.text),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
                if (newPath != null) {
                  setState(() {
                    _settings.journalDirOverride = newPath.trim();
                  });
                }
              },
              description: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _playerJournal.status.online
                          ? Icons.check_circle_outline
                          : Icons.offline_bolt_outlined,
                      size: 16.0,
                      color: _playerJournal.status.online
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _playerJournal.status.online
                          ? 'Player Journal is Online'
                          : 'Player Journal is Offline',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _playerJournal.status.online
                                ? Colors.green
                                : Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
