// lib/repositories/note_repository.dart
import '../models/note.dart';
import '../services/isar_service.dart';

class NoteRepository {
  final IsarService _isarService = IsarService();

  Future<void> addNote(Note note) => _isarService.addNote(note);

  Future<List<Note>> getNotes() => _isarService.getNotes();

  Future<void> deleteNote(int id) => _isarService.deleteNote(id);
}
