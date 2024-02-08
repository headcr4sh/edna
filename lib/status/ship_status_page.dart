import 'package:edna/app_settings.dart';
import 'package:edna/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart' show SettingsList, SettingsSection, SettingsTile;

import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class ShipStatusPage extends StatefulWidget {

  const ShipStatusPage({super.key});

  @override
  State<ShipStatusPage> createState() => _ShipStatusPageState();

}

class _ShipStatusPageState extends State<ShipStatusPage> {

  final _settings = EdnaAppSettings();

  @override
  Widget build(final BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Ship Status'),
      ),
      body: Text('TODO: Add ship status contents.'),
    );
  }

}
