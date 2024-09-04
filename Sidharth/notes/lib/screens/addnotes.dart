import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes/controller/controller.dart';
import 'package:notes/model/notes.dart';
import 'package:notes/model/snackbar.dart';

class AddNotesScreen extends StatelessWidget {
  final Note? note;
  AddNotesScreen({super.key, this.note});

  final String noteDate = DateFormat("dd MMMM").format(DateTime.now());
  final String noteTime = DateFormat("hh:mm a").format(DateTime.now());

  final NotesController notesController = Get.put(NotesController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note!.title;
      contentController.text = note!.content;
      notesController.changeColor(Color(note!.color));
    }

    final characterCount = contentController.text.length.obs;

    contentController.addListener(() {
      characterCount.value = contentController.text.length;
    });

    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: notesController.backgroundColor.value,
          appBar: AppBar(
            backgroundColor: notesController.backgroundColor.value,
            actions: [
              IconButton(
                onPressed: note != null
                    ? () {
                        notesController.deleteNoteAt(
                            notesController.notesList.indexOf(note!));
                        Get.back();
                      }
                    : null,
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  notesController.toggleColorOptions();
                },
                icon: const Icon(Icons.photo),
              ),
              IconButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty &&
                      contentController.text.trim().isEmpty) {
                    showCustomSnackbar(
                        'Error', 'Please provide at least a title or content');
                    return;
                  }

                  final newNote = Note(
                    title: titleController.text,
                    content: contentController.text,
                    date: noteDate,
                    time: noteTime,
                    color: notesController.backgroundColor.value.value,
                  );

                  if (note == null) {
                    notesController.addNote(newNote);
                  } else {
                    notesController.updateNoteAt(
                        notesController.notesList.indexOf(note!), newNote);
                  }

                  Get.back();
                },
                icon: const Icon(Icons.check),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          hintStyle:
                              TextStyle(fontSize: 24, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            note != null ? note!.date : noteDate,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            note != null ? note!.time : noteTime,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Obx(() => Text(
                                '| Characters: ${characterCount.value}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          hintText: 'Start typing',
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (notesController.showColorOptions.value) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildColorOption(
                            Colors.white,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.blue.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.green.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.red.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.yellow.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.orange.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.purple.shade100,
                            notesController,
                          ),
                          _buildColorOption(
                            Colors.pink.shade100,
                            notesController,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildColorOption(Color color, NotesController controller) {
    return InkWell(
      onTap: () {
        controller.changeColor(color);
        controller.showColorOptions.value = false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 15,
          child: controller.backgroundColor.value == color
              ? const Icon(
                  Icons.check,
                  color: Colors.black,
                )
              : null,
        ),
      ),
    );
  }
}
