import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes/model/notes.dart';

class NotesController extends GetxController {
  late Box<Note> notesBox;

  var notesList = <Note>[].obs;
  var selectedNote = Note(
    title: '',
    content: '',
    date: '',
    time: '',
    color: Colors.white.value,
  ).obs;

  var backgroundColor = Colors.white.obs;
  var showColorOptions = false.obs;

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future<void> openBox() async {
    notesBox = await Hive.openBox<Note>('notesBox');
    notesList.value = notesBox.values.toList();
  }

  void addNote(Note note) {
    notesBox.add(note);
    notesList.add(note);
  }

  void deleteNoteAt(int index) {
    notesBox.deleteAt(index);
    notesList.removeAt(index);
  }

  void updateNoteAt(int index, Note note) {
    notesBox.putAt(index, note);
    notesList[index] = note;
  }

  Note getNoteAt(int index) {
    return notesBox.getAt(index)!;
  }

  void setSelectedNote(Note note) {
    selectedNote.value = note;
  }

  void changeColor(Color color) {
    backgroundColor.value = color;
  }

  void toggleColorOptions() {
    showColorOptions.value = !showColorOptions.value;
  }
}
