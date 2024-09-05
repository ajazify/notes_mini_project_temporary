import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/controller.dart';
import 'package:notes/model/snackbar.dart';
import 'package:notes/screens/addnotes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesController notesController = Get.put(NotesController());

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                if (value == 'delete_all') {
                  if (notesController.notesList.isNotEmpty) {
                    _showDeleteConfirmationDialog(context, notesController);
                  } else {
                    showCustomSnackbar('Error', 'No notes to delete');
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete_all',
                  child: Text('Delete All'),
                ),
              ],
            ),
          ],
        ),
        body: notesController.notesList.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.note_add,
                      size: 80,
                      color: Colors.yellow.shade500,
                    ),
                    const Text(
                      'No notes here yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notesController.notesList.length,
                itemBuilder: (context, index) {
                  final note = notesController.getNoteAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(note.color),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 2),
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                note.time,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.to(() => AddNotesScreen(note: note));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddNotesScreen());
          },
          backgroundColor: Colors.yellow.shade700,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, NotesController notesController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete All Notes'),
        content: const Text('Are you sure you want to delete all notes?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notesController.notesList.clear();
              Get.back();
              showCustomSnackbar('Deleted', 'All notes have been deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
