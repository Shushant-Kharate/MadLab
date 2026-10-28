// Experiment 4: To create an interactive Form using form widget.
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 04',
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
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  String course = 'Flutter';
  bool consent = false;
  String? submitted;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    setState(
      () => submitted =
          '${name.text.trim()}\n${email.text.trim()}\nCourse: $course',
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('04 / Interactive Form')),
    body: labBody([
      Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Student registration', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 20),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => (v ?? '').trim().length < 2
                  ? 'Enter at least two characters'
                  : null,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                      .hasMatch((v ?? '').trim())
                  ? null
                  : 'Enter a valid email',
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: course,
              decoration: const InputDecoration(labelText: 'Course'),
              items: [
                'Flutter',
                'Dart',
                'Mobile development',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => course = v!),
            ),
            FormField<bool>(
              initialValue: false,
              validator: (v) =>
                  v == true ? null : 'Please accept the declaration',
              builder: (field) => Column(
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I confirm these details are correct'),
                    value: consent,
                    onChanged: (v) {
                      setState(() => consent = v!);
                      field.didChange(v);
                    },
                  ),
                  if (field.hasError)
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: submit, child: const Text('Submit')),
            TextButton(
              onPressed: () {
                form.currentState!.reset();
                name.clear();
                email.clear();
                setState(() {
                  course = 'Flutter';
                  consent = false;
                  submitted = null;
                });
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
      if (submitted != null)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Registration successful\n$submitted'),
          ),
        ),
    ]),
  );
}
