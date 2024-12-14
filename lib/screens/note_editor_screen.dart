// lib/screens/note_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // Pass a note for editing; null for new note

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final NoteRepository _repository = NoteRepository();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note()
        ..title = _titleController.text
        ..content = _contentController.text
        ..createdAt = widget.note?.createdAt ?? DateTime.now()
        ..id = widget.note?.id ?? Isar.autoIncrement;

      await _repository.addNote(newNote);
      Navigator.pop(context, true); // Return true to indicate a refresh is needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) => value!.isEmpty ? 'Please enter some content' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
