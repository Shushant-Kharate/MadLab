// To Connect Flutter UI with firebase database.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.autoConnect = true});
  final bool autoConnect;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Firebase Student Manager',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: LabPage(autoConnect: autoConnect),
  );
}

class LabPage extends StatefulWidget {
  const LabPage({super.key, this.autoConnect = true});
  final bool autoConnect;
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final scroll = ScrollController();
  List<Map<String, dynamic>> records = [];
  SharedPreferences? prefs;
  FirebaseFirestore? database;
  FirebaseAuth? auth;
  CollectionReference<Map<String, dynamic>>? students;
  String? editingId;
  static bool emulatorsConfigured = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  bool busy = true;
  bool online = false;
  String? error;
  static const project = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'madlab-f5bad',
  );
  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyCEagjjgKadI7DyMGmVa6E3g_ZUjRxxuDM',
  );
  static const appId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '1:706450556489:web:6652cae4c355f4524da198',
  );
  static const sender = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '706450556489',
  );
  static const androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
    defaultValue: '1:706450556489:android:85304ae1c91b2e774da198',
  );
  static const androidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
    defaultValue: 'AIzaSyBgInJbTIoZ-9GrgZKWrDstF9Y28ofJ-Eo',
  );
  static const authDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: 'madlab-f5bad.firebaseapp.com',
  );
  static const useEmulators = bool.fromEnvironment('FIREBASE_EMULATORS');
  static const emulatorHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );

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
    if (!mounted) return;
    setState(() => busy = false);
    if (widget.autoConnect && (project.isNotEmpty || useEmulators)) {
      await connect();
    }
  }

  Future<void> connect() async {
    if (!useEmulators &&
        [
          project,
          kIsWeb ? apiKey : androidApiKey,
          kIsWeb ? appId : androidAppId,
          sender,
        ].any((v) => v.isEmpty)) {
      setState(
        () => error = 'Supply the Firebase configuration described in README. Local demo remains available.',
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
                apiKey: useEmulators
                    ? 'demo-api-key'
                    : kIsWeb
                    ? apiKey
                    : androidApiKey,
                appId: useEmulators
                    ? '1:1234567890:web:madlab'
                    : kIsWeb
                    ? appId
                    : androidAppId,
                messagingSenderId: useEmulators ? '1234567890' : sender,
                projectId: useEmulators ? 'demo-madlab' : project,
                authDomain: authDomain,
              ),
            ).timeout(const Duration(seconds: 15))
          : Firebase.app();
      database = FirebaseFirestore.instanceFor(app: app);
      auth = FirebaseAuth.instanceFor(app: app);
      if (useEmulators && !emulatorsConfigured) {
        await auth!.useAuthEmulator(emulatorHost, 9099);
        database!.useFirestoreEmulator(emulatorHost, 8081);
        emulatorsConfigured = true;
      }
      final user =
          auth!.currentUser ??
          (await auth!.signInAnonymously().timeout(const Duration(seconds: 15)))
              .user;
      if (user == null) throw StateError('Sign-in failed');
      final collection = database!
          .collection('users')
          .doc(user.uid)
          .collection('students');
      await collection
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        online = true;
        students = collection;
        editingId = null;
        name.clear();
        email.clear();
        records = [];
      });
      subscription = collection
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
      editingId = null;
      name.clear();
      email.clear();
      busy = true;
    });
    try {
      final saved = prefs?.getString('students');
      if (mounted) {
        setState(
          () => records = saved == null
              ? []
              : (jsonDecode(saved) as List)
                    .map((v) => Map<String, dynamic>.from(v))
                    .toList(),
        );
      }
    } catch (_) {
      if (mounted) setState(() => error = 'Could not read local records.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> add() async {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final student = {'name': name.text.trim(), 'email': email.text.trim()};
      if (online) {
        if (editingId == null) {
          await students!
              .add({
                ...student,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              })
              .timeout(const Duration(seconds: 15));
        } else {
          await students!
              .doc(editingId)
              .update({...student, 'updatedAt': FieldValue.serverTimestamp()})
              .timeout(const Duration(seconds: 15));
        }
      } else {
        final next = editingId == null
            ? [
                {
                  'id': DateTime.now().microsecondsSinceEpoch.toString(),
                  ...student,
                },
                ...records,
              ]
            : records
                  .map(
                    (record) => record['id'] == editingId
                        ? {...record, ...student}
                        : record,
                  )
                  .toList();
        if (prefs == null ||
            !await prefs!.setString('students', jsonEncode(next))) {
          throw StateError('Local save failed');
        }
        if (mounted) setState(() => records = next);
      }
      name.clear();
      email.clear();
      if (mounted) setState(() => editingId = null);
    } catch (e) {
      if (mounted) setState(() => error = 'Save failed: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete student?'),
        content: const Text('This removes the selected student record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (online) {
        await students!.doc(id).delete().timeout(const Duration(seconds: 15));
      } else {
        final next = records.where((r) => r['id'] != id).toList();
        if (prefs == null ||
            !await prefs!.setString('students', jsonEncode(next))) {
          throw StateError('Local delete failed');
        }
        if (mounted) setState(() => records = next);
      }
      if (editingId == id && mounted) cancelEdit();
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
    scroll.dispose();
    super.dispose();
  }

  void edit(Map<String, dynamic> student) {
    setState(() {
      editingId = student['id'] as String;
      name.text = student['name'] as String;
      email.text = student['email'] as String;
      error = null;
    });
    scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void cancelEdit() {
    setState(() {
      editingId = null;
      name.clear();
      email.clear();
    });
    form.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('09 / Firebase Student Manager')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.all(24),
            children: [
              Chip(
                label: Text(
                  online
                      ? useEmulators
                            ? 'Firebase emulators connected'
                            : 'Cloud Firestore connected'
                      : 'Local demo - saved on this device',
                ),
              ),
              const Text(
                'Local and cloud records are separate. Connecting does not upload local records.',
              ),
              if (online)
                SelectableText(
                  'Signed in anonymously. Your records are private to this identity.\nUser: ${auth?.currentUser?.uid ?? ""}',
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
                      enabled: !busy,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                      ),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Enter a name' : null,
                    ),
                    TextFormField(
                      controller: email,
                      enabled: !busy,
                      maxLength: 254,
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
                      child: Text(
                        editingId == null ? 'Save Student' : 'Update Student',
                      ),
                    ),
                    if (editingId != null)
                      TextButton(
                        onPressed: busy ? null : cancelEdit,
                        child: const Text('Cancel edit'),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit student',
                          onPressed: busy ? null : () => edit(student),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete student',
                          onPressed: busy
                              ? null
                              : () => delete('${student['id']}'),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Your anonymous sign-in persists on this browser/device. Clearing app data loses access to that identity.',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
