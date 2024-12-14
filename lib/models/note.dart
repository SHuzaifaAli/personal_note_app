// lib/models/note.dart
import 'package:isar/isar.dart';

part 'note.g.dart'; // Run code generation after creating the model

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  late DateTime createdAt;
  List<String> tags = [];
}
