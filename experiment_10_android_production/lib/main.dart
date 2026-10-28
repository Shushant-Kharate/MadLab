// To test and deploy production ready Flutter App on Android platform.
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Connect a real monitoring sink here for a deployed product.
    debugPrint('Framework error: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform error: $error');
    debugPrintStack(stackTrace: stack);
    return true;
  };
  ErrorWidget.builder = (_) => const Material(
    child: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Something went wrong. Please restart the app.'),
        ),
      ),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Android Production Lab',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.system,
    home: const LabPage(),
  );
}

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  int counter = 0;
  String status = 'Ready for testing';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('10 / Android Production')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(Icons.android, size: 80),
              Text(
                'Your app is running!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Build mode: ${kReleaseMode
                    ? "release"
                    : kProfileMode
                    ? "profile"
                    : "debug"}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '$counter',
                key: const ValueKey('counter'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              FilledButton(
                onPressed: () => setState(() => counter++),
                child: const Text('Test Button'),
              ),
              TextButton(
                onPressed: () => setState(() => counter = 0),
                child: const Text('Reset counter'),
              ),
              OutlinedButton(
                onPressed: () {
                  try {
                    throw StateError('Simulated recoverable failure');
                  } catch (_) {
                    setState(
                      () =>
                          status = 'Recovered safely from a simulated failure',
                    );
                  }
                },
                child: const Text('Test recovery'),
              ),
              Text(status, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              const SelectableText(
                'flutter analyze\nflutter test\nflutter run --release -d <android-device-id>\nflutter build apk --release\nflutter build appbundle --release',
              ),
              const Text(
                'A lab build is not a store release. See README for signing, device tests, versioning and Play Console steps.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
