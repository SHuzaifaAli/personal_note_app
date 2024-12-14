// lib/services/isar_service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  late Future<Isar> db;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!; // Return the existing instance
    }
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([NoteSchema], directory: dir.path);
  }

  // CRUD operations
  Future<void> addNote(Note note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  Future<List<Note>> getNotes() async {
    final isar = await db;
    return await isar.notes.where().findAll();
  }

  Future<void> deleteNote(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }
}
