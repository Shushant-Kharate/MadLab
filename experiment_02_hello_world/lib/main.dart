// Experiment 2: To run basic flutter hello world app.
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 02',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const LabPage(),
  );
}

Widget labBody(List<Widget> children) => SafeArea(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 850),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final child in children)
            Padding(padding: const EdgeInsets.only(bottom: 16), child: child),
        ],
      ),
    ),
  ),
);

void message(BuildContext context, String value) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));

class LabPage extends StatelessWidget {
  const LabPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('02 / Hello World')),
    body: labBody([
      const FlutterLogo(size: 100),
      const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
      const Text(
        'My first Flutter application. main() calls runApp(), MaterialApp provides the theme, and Scaffold provides the screen.',
      ),
      FilledButton(
        onPressed: () => message(context, 'Hello from Flutter!'),
        child: const Text('Say hello'),
      ),
    ]),
  );
}
