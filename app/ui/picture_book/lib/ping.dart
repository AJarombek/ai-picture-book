import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ping extends StatefulWidget {
  const Ping({super.key});

  @override
  State<Ping> createState() => _PingState();
}

class _PingState extends State<Ping> {
  Future<String> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:8000/'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ping'),
      ),
      body: Center(
        child: FutureBuilder<String>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = json.decode(snapshot.data!);
                return Text('Data: $data');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }
        ),
      ),
    );
  }
}