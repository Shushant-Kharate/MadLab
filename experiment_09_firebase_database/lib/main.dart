// To Connect Flutter UI with firebase database.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Firebase Student Manager',
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
  final name = TextEditingController(), email = TextEditingController();
  List<Map<String, dynamic>> records = [];
  SharedPreferences? prefs;
  FirebaseFirestore? database;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  bool busy = true;
  bool online = false;
  String? error;
  static const project = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const sender = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      prefs = await SharedPreferences.getInstance();
      final saved = prefs!.getString('students');
      if (saved != null) {
        records = (jsonDecode(saved) as List)
            .map((v) => Map<String, dynamic>.from(v))
            .toList();
      }
    } catch (e) {
      error = 'Local storage unavailable: $e';
    }
    if (mounted) setState(() => busy = false);
  }

  Future<void> connect() async {
    if ([project, apiKey, appId, sender].any((v) => v.isEmpty)) {
      setState(
        () => error = 'Supply the four FIREBASE_* dart defines described in README. Local demo remains available.',
      );
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final app = Firebase.apps.isEmpty
          ? await Firebase.initializeApp(
              options: const FirebaseOptions(
                apiKey: apiKey,
                appId: appId,
                messagingSenderId: sender,
                projectId: project,
              ),
            ).timeout(const Duration(seconds: 15))
          : Firebase.app();
      database = FirebaseFirestore.instanceFor(app: app);
      await database!
          .collection('students')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        online = true;
        records = [];
      });
      subscription = database!
          .collection('students')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (event) {
              if (mounted) {
                setState(() {
                  records = event.docs
                      .map((d) => {'id': d.id, ...d.data()})
                      .toList();
                  error = null;
                });
              }
            },
            onError: (Object e) {
              if (mounted) setState(() => error = 'Firebase read failed: $e');
            },
          );
    } catch (e) {
      if (mounted) {
        setState(
          () => error =
              'Firebase connection failed: $e. Local demo is still active.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> useLocal() async {
    await subscription?.cancel();
    subscription = null;
    if (!mounted) return;
    setState(() {
      online = false;
      error = null;
      records = [];
      busy = true;
    });
    await initialize();
  }

  Future<void> add() async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final student = {'name': name.text.trim(), 'email': email.text.trim()};
      if (online) {
        await database!
            .collection('students')
            .add({...student, 'createdAt': FieldValue.serverTimestamp()})
            .timeout(const Duration(seconds: 15));
      } else {
        final next = [
          {'id': DateTime.now().microsecondsSinceEpoch.toString(), ...student},
          ...records,
        ];
        if (prefs == null ||
            !await prefs!.setString('students', jsonEncode(next))) {
          throw StateError('Local save failed');
        }
        if (mounted) setState(() => records = next);
      }
      name.clear();
      email.clear();
    } catch (e) {
      if (mounted) setState(() => error = 'Save failed: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> delete(String id) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (online) {
        await database!
            .collection('students')
            .doc(id)
            .delete()
            .timeout(const Duration(seconds: 15));
      } else {
        final next = records.where((r) => r['id'] != id).toList();
        if (prefs == null ||
            !await prefs!.setString('students', jsonEncode(next))) {
          throw StateError('Local delete failed');
        }
        if (mounted) setState(() => records = next);
      }
    } catch (e) {
      if (mounted) setState(() => error = 'Delete failed: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('09 / Firebase Student Manager')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Chip(
                label: Text(
                  online
                      ? 'Cloud Firestore connected'
                      : 'Local demo - saved on this device',
                ),
              ),
              const Text(
                'Local and cloud records are separate. Connecting does not upload local records.',
              ),
              TextButton(
                onPressed: busy
                    ? null
                    : online
                    ? useLocal
                    : connect,
                child: Text(
                  online ? 'Switch to local demo' : 'Connect Firebase',
                ),
              ),
              if (busy) const LinearProgressIndicator(),
              if (error != null)
                SelectableText(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                      ),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Enter a name' : null,
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
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: busy ? null : add,
                      child: const Text('Save Student'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${records.length} students',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (records.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No students found'),
                ),
              for (final student in records)
                Card(
                  child: ListTile(
                    title: Text('${student['name']}'),
                    subtitle: Text('${student['email']}'),
                    trailing: IconButton(
                      tooltip: 'Delete student',
                      onPressed: busy ? null : () => delete('${student['id']}'),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
