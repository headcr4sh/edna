import 'package:flutter/material.dart';

import './ed_server_status.dart';

class ServerStatusLabel extends StatelessWidget {
  final ServerStatus status;

  ServerStatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      decoration: BoxDecoration(
        color: status.isGood ? Colors.green : status.isMaintenance ? Colors.red : Colors.yellow,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          Text('Server status:', style: TextStyle(color: Colors.white)),
          Text(
            status.status ?? 'Unknown',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(status.isGood ? Icons.cloud_done_outlined : status.isMaintenance ? Icons.cloud_off_rounded : Icons.question_mark_outlined, color: Colors.white, size: 16.0,),
        ],
      ),
    );
  }
}
