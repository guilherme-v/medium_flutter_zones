import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runZoned(
    () {
      runApp(MyApp());
    },
    zoneSpecification: ZoneSpecification(
      // Intercept all print calls
      print: (self, parent, zone, line) async {
        // Paint all logs with White color
        final pen = AnsiPen()..white(bold: true);
        // Include a timestamp and the name of the App - 'MyApp' in this case
        final messageToLog = "[${DateTime.now()}] MyApp: $line";
        // Send the message to our local server that is running locally
        logLocally(messageToLog);
        // Also print the message in the "Debug Console"
        parent.print(zone, pen(messageToLog));
      },
    ),
  );
}

Future<File> writeLine(String line) async {
  final file = File('./customLogs.tmp');
  return file.writeAsString('$line');
}

Future<void> logLocally(String line) async {
  // When using Android Emulator the address '127.0.0.1' is a loopback interface
  // to target a server running in the local machine use '10.0.0.2' instead
  var url = 'http://10.0.2.2:8082/';
  http.post(url, body: jsonEncode(line));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      print("Counter: ${_counter}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'print',
        child: Icon(Icons.print),
      ),
    );
  }
}
