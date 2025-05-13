import 'package:dart_server/server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isRunning = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: isRunning ? Colors.red : Colors.green),
            onPressed: () async {
              isRunning = (await http.get(Uri.parse('http://localhost:8080'))).statusCode == 200;
              isRunning ? http.get(Uri.parse('http://localhost:8080/close')) : runServer();
            },
            child: Text(isRunning ? 'Close Server' : 'Run Server'),
          ),
        ),
      ),
    );
  }
}
