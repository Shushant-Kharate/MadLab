// Experiment 1: To install and configure Flutter Environment.
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 01',
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

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final done = <int>{};
  final steps = const [
    (
      'Install Flutter SDK',
      'git clone --branch stable https://github.com/flutter/flutter.git',
    ),
    ('Add Flutter to PATH', 'Add the SDK bin directory to your shell PATH.'),
    ('Check toolchain', 'flutter doctor -v'),
    ('Check devices', 'flutter devices'),
    ('Resolve packages', 'flutter pub get'),
    ('Launch this experiment', 'flutter run -d chrome'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('01 / Flutter Environment')),
    body: labBody([
      const FlutterLogo(size: 80),
      const Text('Environment verification', style: TextStyle(fontSize: 28)),
      const Text(
        'This app runs after Flutter is installed. Check each item only after running its command. It cannot install the SDK itself.',
      ),
      LinearProgressIndicator(value: done.length / steps.length),
      Text('${done.length} / ${steps.length} verified'),
      for (var i = 0; i < steps.length; i++)
        CheckboxListTile(
          title: Text(steps[i].$1),
          subtitle: SelectableText(steps[i].$2),
          value: done.contains(i),
          onChanged: (v) => setState(() {
            v == true ? done.add(i) : done.remove(i);
          }),
        ),
    ]),
  );
}
