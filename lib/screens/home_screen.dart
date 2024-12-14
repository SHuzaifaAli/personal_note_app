// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteRepository _repository = NoteRepository();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_searchNotes);
  }

  void _loadNotes() async {
    final notes = await _repository.getNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  void _deleteNote(int id) async {
    await _repository.deleteNote(id);
    _loadNotes();
  }

  void _navigateToEditor({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditorScreen(note: note)),
    );
    if (result == true) _loadNotes(); // Refresh notes after editing or adding
  }

  void _searchNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _filteredNotes.isEmpty
          ? const Center(child: Text('No notes found'))
          : ListView.builder(
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) => NoteCard(
          note: _filteredNotes[index],
          onDelete: () => _deleteNote(_filteredNotes[index].id),
          onTap: () => _navigateToEditor(note: _filteredNotes[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
