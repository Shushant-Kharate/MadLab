// Experiment 7: To apply navigation, routing and gestures in Flutter App.
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 07',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const LabPage(),
    routes: {'/second': (_) => const SecondScreen()},
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

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  String gesture = 'Try a gesture';
  int taps = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('07 / Navigation & Gestures')),
    body: labBody([
      const Text('Home screen', style: TextStyle(fontSize: 28)),
      FilledButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/second',
          arguments: 'Hello from Home',
        ),
        child: const Text('Open second screen'),
      ),
      GestureDetector(
        onTap: () => setState(() {
          taps++;
          gesture = 'Tap ($taps)';
        }),
        onDoubleTap: () => setState(() => gesture = 'Double tap'),
        onLongPress: () => setState(() => gesture = 'Long press'),
        onHorizontalDragEnd: (d) => setState(
          () => gesture = (d.primaryVelocity ?? 0) < 0
              ? 'Swipe left'
              : 'Swipe right',
        ),
        child: Container(
          height: 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'Tap / double tap / long press / swipe',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Text(
        gesture,
        key: const ValueKey('gesture'),
        style: const TextStyle(fontSize: 24),
      ),
    ]),
  );
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Second Screen')),
    body: labBody([
      Text(
        ModalRoute.of(context)?.settings.arguments as String? ??
            'Second screen',
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back to Home'),
      ),
    ]),
  );
}
