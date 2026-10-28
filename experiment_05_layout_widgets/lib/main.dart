// Experiment 5: To design a layout of Flutter App using layout widgets.
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 05',
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
  Widget tile(IconData icon, String title, String text) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.indigo.shade50,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontSize: 22)),
        Text(text, textAlign: TextAlign.center),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('05 / Layout Widgets')),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, bounds) {
          final cards = [
            tile(Icons.view_column, 'Column', 'Vertical arrangement'),
            tile(Icons.table_rows, 'Row', 'Horizontal arrangement'),
            tile(
              Icons.space_dashboard,
              'Expanded',
              'Share the available width',
            ),
          ];
          return labBody([
            Container(
              padding: const EdgeInsets.all(28),
              color: Colors.indigo,
              child: const Column(
                children: [
                  Icon(Icons.flutter_dash, color: Colors.white, size: 60),
                  Text(
                    'Flutter Layout Practice',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ],
              ),
            ),
            Text(
              'Viewport: ${bounds.maxWidth.round()} px / ${bounds.maxWidth >= 650 ? "Row" : "Column"} layout',
            ),
            if (bounds.maxWidth >= 650)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final card in cards)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: card,
                      ),
                    ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final card in cards)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: card,
                    ),
                ],
              ),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Second Screen')),
                    body: labBody([
                      tile(
                        Icons.dashboard,
                        'Second Screen',
                        'Padding, Container and Column',
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Home'),
                      ),
                    ]),
                  ),
                ),
              ),
              child: const Text('Open second screen'),
            ),
          ]);
        },
      ),
    ),
  );
}
