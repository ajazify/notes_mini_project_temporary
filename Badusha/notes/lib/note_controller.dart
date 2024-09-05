import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes/note.dart';

class NoteController extends GetxController {
  var characterCount = 0.obs;
  var selectedColor = 0xFFFFFFFF.obs;
  final Box<Note> notesBox = Hive.box<Note>('notes');

  void updateCharacterCount(String text) {
    characterCount.value = text.length;
  }

  void addNote(String title, String content, int color) {
    String noteDate = DateTime.now().toIso8601String();
    Note newNote = Note(
      title: title,
      content: content,
      color: color,
      date: noteDate,
    );
    notesBox.add(newNote);
  }

  void updateNote(int index, String title, String content, int color) {
    String noteDate = DateTime.now().toIso8601String();
    Note updatedNote = Note(
      title: title,
      content: content,
      color: color,
      date: noteDate,
    );
    notesBox.putAt(index, updatedNote);
  }

  void deleteNoteAt(int index) {
    notesBox.deleteAt(index);
  }

  List<Note> getNotes() {
    return notesBox.values.toList();
  }
}
