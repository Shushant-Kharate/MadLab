// Implementation of Mini Project on selected case study: Student Study Planner.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Study Planner',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const LabPage(),
  );
}

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController();
  String subject = 'Flutter', filter = 'All';
  List<Map<String, dynamic>> tasks = [];
  SharedPreferences? prefs;
  bool busy = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      prefs = await SharedPreferences.getInstance();
      final saved = prefs!.getString('study_tasks');
      if (saved != null) {
        tasks = (jsonDecode(saved) as List)
            .map((t) => Map<String, dynamic>.from(t))
            .toList();
      }
    } catch (e) {
      error = 'Could not load tasks: $e';
    }
    if (mounted) setState(() => busy = false);
  }

  Future<void> commit(List<Map<String, dynamic>> next) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (prefs == null ||
          !await prefs!.setString('study_tasks', jsonEncode(next))) {
        throw StateError('Storage unavailable');
      }
      if (mounted) setState(() => tasks = next);
    } catch (e) {
      if (mounted) setState(() => error = 'Could not save tasks: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> add() async {
    if (!form.currentState!.validate()) return;
    await commit([
      ...tasks,
      {
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'title': title.text.trim(),
        'subject': subject,
        'done': false,
      },
    ]);
    if (error == null) title.clear();
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t['done'] == true).length;
    final visible = tasks
        .where(
          (t) =>
              filter == 'All' || (filter == 'Completed') == (t['done'] == true),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('11 / Study Planner')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Plan. Study. Complete.',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text('$completed / ${tasks.length} tasks complete'),
                LinearProgressIndicator(
                  value: tasks.isEmpty ? 0 : completed / tasks.length,
                ),
                if (busy) const Text('Loading / saving...'),
                if (error != null) Text(error!),
                Form(
                  key: form,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: title,
                        decoration: const InputDecoration(
                          labelText: 'Task title',
                        ),
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Enter a task' : null,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: subject,
                        decoration: const InputDecoration(labelText: 'Subject'),
                        items: ['Flutter', 'Dart', 'Android']
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (s) => setState(() => subject = s!),
                      ),
                      FilledButton(
                        onPressed: busy ? null : add,
                        child: const Text('Add task'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final f in ['All', 'Pending', 'Completed'])
                      ChoiceChip(
                        label: Text(f),
                        selected: filter == f,
                        onSelected: (_) => setState(() => filter = f),
                      ),
                  ],
                ),
                if (visible.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No tasks in this view'),
                  ),
                for (final task in visible)
                  Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task['done'] == true,
                        onChanged: busy
                            ? null
                            : (v) => commit(
                                tasks
                                    .map(
                                      (t) => t['id'] == task['id']
                                          ? {...t, 'done': v}
                                          : t,
                                    )
                                    .toList(),
                              ),
                      ),
                      title: Text('${task['title']}'),
                      subtitle: Text('${task['subject']}'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Task details')),
                            body: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${task['title']}',
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  Text('Subject: ${task['subject']}'),
                                  Text(
                                    task['done'] == true
                                        ? 'Completed'
                                        : 'Pending',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: 'Delete task',
                        onPressed: busy
                            ? null
                            : () => commit(
                                tasks
                                    .where((t) => t['id'] != task['id'])
                                    .toList(),
                              ),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ),
                const Text(
                  'Local device storage. Tasks persist after restarting; clearing browser/app data removes them.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
