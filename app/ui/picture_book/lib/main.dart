import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picture_book/ping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Picture Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'AI Picture Book'),
        '/ping': (context) => const Ping(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _responseText = '';
  bool _isLoading = false;

  void _sendDataToServer() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://localhost:8000/echo?user_input=hi'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _responseText = response.body;
        _isLoading = false;
      });
    } else {
      setState(() {
        _responseText = 'Error: ${response.statusCode}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendDataToServer,
              child: const Text('Send'),
            ),
            const SizedBox(height: 20.0),
            _isLoading ?
            SpinKitCircle(
              color: Theme.of(context).colorScheme.primary,
              size: 50.0,
            )
            :
            Expanded(
              child: Center(
                child: Text(_responseText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
