import 'dart:developer';
import 'dart:io';

import 'package:dart_server/server.dart';
import 'package:flutter/material.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  HttpServer? server;
  bool isRunning = false;
  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(echoRequest);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: isRunning ? Colors.red : Colors.green),
            onPressed: () async {
              isRunning = server != null;
              if (isRunning) {
                server!.close();
                server = null;
              } else {
                server = await shelf_io.serve(handler, '0.0.0.0', 11690);
                log('http://${server!.address.address}:${server!.port}');
              }
              isRunning = server != null;
              setState(() {});
            },
            child: Text(isRunning ? 'Close Server' : 'Run Server'),
          ),
        ),
      ),
    );
  }
}
