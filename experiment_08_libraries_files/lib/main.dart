// Experiment 8: To include libraries and working with files in Flutter app.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MAD Lab 08',
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
  final editor = TextEditingController();
  String fileName = 'No file selected',
      status = 'Choose a UTF-8 text, CSV or JSON file (up to 1 MB).';
  int size = 0;
  bool busy = false;
  @override
  void dispose() {
    editor.dispose();
    super.dispose();
  }

  Future<void> open() async {
    setState(() => busy = true);
    try {
      final file = await openFile(
        acceptedTypeGroups: [
          const XTypeGroup(
            label: 'Text files',
            extensions: ['txt', 'csv', 'json'],
            mimeTypes: ['text/plain', 'text/csv', 'application/json'],
            uniformTypeIdentifiers: ['public.text', 'public.json'],
          ),
        ],
      );
      if (file == null) return;
      final length = await file.length();
      if (length > 1024 * 1024) {
        throw const FormatException('Choose a file smaller than 1 MB.');
      }
      final content = utf8.decode(await file.readAsBytes());
      if (!mounted) return;
      setState(() {
        editor.text = content;
        fileName = file.name;
        size = length;
        status = 'File read successfully';
      });
    } catch (e) {
      if (mounted) setState(() => status = 'Could not read file: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      final file = XFile.fromData(
        Uint8List.fromList(utf8.encode(editor.text)),
        mimeType: 'text/plain',
        name: 'madlab-notes.txt',
      );
      // Web uses a download; Android uses the native document creation dialog.
      if (kIsWeb) {
        await file.saveTo('madlab-notes.txt');
      } else {
        final location = await FilePicker.platform.saveFile(
          fileName: 'madlab-notes.txt',
          type: FileType.custom,
          allowedExtensions: ['txt'],
          bytes: Uint8List.fromList(utf8.encode(editor.text)),
        );
        if (location == null) return;
      }
      if (mounted) setState(() => status = 'File exported');
    } catch (e) {
      if (mounted) setState(() => status = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('08 / Libraries & Files')),
    body: labBody([
      const Icon(Icons.folder_open, size: 64),
      Text(status),
      Text('$fileName / $size bytes'),
      Wrap(
        spacing: 12,
        children: [
          FilledButton(
            onPressed: busy ? null : open,
            child: const Text('Choose File'),
          ),
          OutlinedButton(
            onPressed: busy ? null : save,
            child: const Text('Export text'),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () => setState(() {
                    editor.clear();
                    fileName = 'No file selected';
                    size = 0;
                    status = 'Cleared';
                  }),
            child: const Text('Clear'),
          ),
        ],
      ),
      TextField(
        controller: editor,
        minLines: 8,
        maxLines: 20,
        decoration: const InputDecoration(
          labelText: 'File content (editable)',
          border: OutlineInputBorder(),
        ),
      ),
      const Text(
        'Libraries: material, foundation, dart:convert, dart:typed_data, file_selector and file_picker.',
      ),
    ]),
  );
}
