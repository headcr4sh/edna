import 'package:flutter/material.dart';

import 'package:edna/status/session_storage.dart';

class ShipStatusPage extends StatefulWidget {
  const ShipStatusPage({super.key});

  @override
  State<ShipStatusPage> createState() => _ShipStatusPageState();
}

class _ShipStatusPageState extends State<ShipStatusPage> {
  final _sessionStorage = SessionStorage();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Status'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _sessionStorage,
        builder: (context, _) {
          final materials = _sessionStorage.materials;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Materials',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      if (materials == null)
                        const Text('No materials data received yet.')
                      else ...[
                        Text('Items: ${materials.items?.length ?? 0}'),
                        Text(
                            'Components: ${materials.components?.length ?? 0}'),
                        Text(
                            'Consumables: ${materials.consumables?.length ?? 0}'),
                        Text('Data: ${materials.data?.length ?? 0}'),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
