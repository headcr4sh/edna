import 'package:flutter/material.dart';

import 'package:edna/status/session_storage.dart';

class PilotInformationPage extends StatefulWidget {
  const PilotInformationPage({super.key});

  @override
  State<PilotInformationPage> createState() => _PilotInformationPageState();
}

class _PilotInformationPageState extends State<PilotInformationPage> {
  final _sessionStorage = SessionStorage();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilot Information'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _sessionStorage,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rank',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      if (_sessionStorage.rank == null)
                        const Text('No rank data received yet.')
                      else
                        Text(
                            'Combat: ${_sessionStorage.rank?.combat ?? 0}\nTrade: ${_sessionStorage.rank?.trade ?? 0}\nExplore: ${_sessionStorage.rank?.explore ?? 0}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Progress',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      if (_sessionStorage.progress == null)
                        const Text('No progress data received yet.')
                      else
                        Text(
                            'Combat: ${_sessionStorage.progress?.combat ?? 0}%\nTrade: ${_sessionStorage.progress?.trade ?? 0}%\nExplore: ${_sessionStorage.progress?.explore ?? 0}%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Statistics',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      if (_sessionStorage.statistics == null)
                        const Text('No statistics data received yet.')
                      else
                        const Text('Statistics payload received and cached.'),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
