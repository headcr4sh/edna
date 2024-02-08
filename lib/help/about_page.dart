import 'package:edna/app_settings.dart';
import 'package:edna/player_journal/player_journal.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

import '../ed_server_status/ed_server_status.dart' show ServerStatus, ServerStatusLabel;

class AboutPage extends StatefulWidget {

  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => AboutPageState();

}

class AboutPageState extends State<AboutPage> {

  final _settings = EdnaAppSettings();
  final _playerJournal = PlayerJournal();
  final _serverStatus = ServerStatus()..refresh();

  @override
  Widget build(final BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('About E.D.N.A.'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
        children: [
          Container(
          width: 96.0,
          height: 96.0,
          alignment: Alignment.center,
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
        ],
      ),
    );
  }

}
