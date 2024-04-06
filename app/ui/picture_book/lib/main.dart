import 'dart:async';

import 'package:eventflux/eventflux.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:picture_book/ping.dart';
import 'package:picture_book/utils.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(title: 'AI Picture Book'),
    ),
    GoRoute(
      path: '/ping',
      builder: (context, state) => const Ping(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Picture Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final StreamController<String> _streamController = StreamController<String>();
  late http.Client client;
  late http.Response response;
  bool _isLoading = false;
  String _fullMessage = '';

  @override
  void initState() {
    super.initState();
    client = http.Client();
  }

  void _sendDataToServer() async {
    setState(() {
      _isLoading = true;
      _fullMessage = '';
    });

    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      'http://localhost:8000/generate?user_input=${_controller.text}',
      onSuccessCallback: (EventFluxResponse? response) {
        response?.stream?.listen((data) {
          setState(() {
            _fullMessage += transformString(data.data);
          });
          _streamController.add(_fullMessage);
        });
      },
      onError: (error) {
        _streamController.addError('Error: ${error.message}');
      },
      autoReconnect: false,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            )
          ),
        ),
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
            Expanded(
              child: StreamBuilder<String>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                          'Error: ${snapshot.error}',
                          maxLines: null,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red
                          )
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: SelectableText(
                        snapshot.data ?? '',
                        maxLines: null,
                        style: const TextStyle(fontSize: 18)
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.close();
    _streamController.close();
    super.dispose();
  }
}
