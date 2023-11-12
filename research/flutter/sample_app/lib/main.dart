import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'The Penultimate Click Battle'),
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
  int _andyCounter = 0;
  int _ianCounter = 0;

  void _incrementCounter(String name) {
    setState(() {
      if (name == 'Ian') _ianCounter++;
      if (name == 'Andy') _andyCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://avatars.githubusercontent.com/u/1368966?v=4',
                  height: 150,
                  width: 150,
                ),
                Text(
                  'Ian',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_ianCounter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton(
                  onPressed: () => _incrementCounter('Ian'),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://avatars.githubusercontent.com/u/12420525?v=4',
                  height: 150,
                  width: 150,
                ),
                Text(
                  'Andy',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_andyCounter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton(
                  onPressed: () => _incrementCounter('Andy'),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
