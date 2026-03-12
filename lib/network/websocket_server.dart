import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:edna/player_journal/player_journal.dart';
import 'package:edna/network/mdns_manager.dart';

class WebsocketServer {
  static final WebsocketServer _instance = WebsocketServer._internal();

  factory WebsocketServer() => _instance;

  HttpServer? _server;
  MdnsManager? _mdnsManager;
  final Set<WebSocket> _clients = {};
  StreamSubscription<PlayerJournalEventRecord>? _subscription;
  PlayerJournalEventRecordSource? _source;

  WebsocketServer._internal();

  bool get isRunning => _server != null;
  int? get port => _server?.port;

  Future<void> start(PlayerJournalEventRecordSource source) async {
    if (isRunning) return;

    _source = source;
    try {
      // Bind to an unprivileged/random port
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      debugPrint('WebSocket server started on port ${_server!.port}');

      // Register via mDNS
      _mdnsManager = await MdnsManager.get(port: _server!.port);

      // Listen to source events to broadcast to clients
      _subscription = _source!.stream().listen((event) {
        final jsonValue = jsonEncode(event.rawJson);
        for (var client in _clients) {
          try {
            client.add(jsonValue);
          } catch (e) {
            debugPrint('Error sending to client: $e');
          }
        }
      });

      _server!.listen((HttpRequest request) async {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          _clients.add(socket);
          debugPrint('Client connected: ${request.connectionInfo?.remoteAddress.address}');

          // You could optionally send recent history here if we buffered it
          
          socket.listen((message) {
            // Ignore messages from client, server is broadcast-only
          }, onDone: () {
            _clients.remove(socket);
            debugPrint('Client disconnected: ${request.connectionInfo?.remoteAddress.address}');
          }, onError: (error) {
            _clients.remove(socket);
            debugPrint('Client error: $error');
          });
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.close();
        }
      });
    } catch (e) {
      debugPrint('Error starting WebSocket server: $e');
      await stop();
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    for (var client in _clients) {
      await client.close();
    }
    _clients.clear();

    await _mdnsManager?.stop();
    _mdnsManager = null;

    await _server?.close(force: true);
    _server = null;
    
    debugPrint('WebSocket server stopped');
  }
}
