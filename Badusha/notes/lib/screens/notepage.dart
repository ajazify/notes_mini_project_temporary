import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/note_controller.dart';
import 'package:intl/intl.dart';
import 'package:notes/note.dart';

class Notepage extends StatelessWidget {
  final Note? note;
  final int? index;

  const Notepage({super.key, this.note, this.index});

  @override
  Widget build(BuildContext context) {
    final String noteDate = DateFormat("dd MMMM").format(DateTime.now());
    final String noteTime = DateFormat("hh:mm a").format(DateTime.now());

    final NoteController controller = Get.put(NoteController());
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    controller.characterCount.value = contentController.text.length;

    if (note != null) {
      controller.selectedColor.value = note!.color;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (index != null) {
                controller.deleteNoteAt(index!);
                Get.back();
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              _showThemeSelector(context, controller);
            },
            icon: Image.asset(
              'assets/image/tshirt.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
          IconButton(
            onPressed: () {
              if (titleController.text.isNotEmpty ||
                  contentController.text.isNotEmpty) {
                if (index == null) {
                  controller.addNote(
                    titleController.text,
                    contentController.text,
                    controller.selectedColor.value,
                  );
                } else {
                  controller.updateNote(
                    index!,
                    titleController.text,
                    contentController.text,
                    controller.selectedColor.value,
                  );
                }
                Get.back();
              } else {
                Get.snackbar('Empty Note', 'Please enter a title or content.',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => Container(
            color: Color(controller.selectedColor.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 194, 193, 193),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        noteDate,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 191, 191, 191),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        noteTime,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 191, 191, 191),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Obx(
                        () => Text(
                          '${controller.characterCount.value} characters',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 191, 191, 191),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 18),
                  child: TextFormField(
                    controller: contentController,
                    onChanged: (text) {
                      controller.updateCharacterCount(text);
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Start typing',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 191, 191, 191),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context, NoteController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 240,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildColorOption(const Color.fromARGB(255, 255, 255, 255),
                    controller, context),
                _buildColorOption(const Color(0xFFFFD1DC), controller, context),
                _buildColorOption(const Color(0xFFB39EB5), controller, context),
                _buildColorOption(const Color(0xFFA1C6EA), controller, context),
                _buildColorOption(const Color(0xFF98FF98), controller, context),
                _buildColorOption(const Color(0xFFFFFACD), controller, context),
                _buildColorOption(const Color(0xFFFFB347), controller, context),
                _buildColorOption(const Color(0xFFE5E4E2), controller, context),
                _buildColorOption(const Color(0xFFFAF0E6), controller, context),
                _buildColorOption(const Color(0xFFACE1AF), controller, context),
                _buildColorOption(const Color(0xFFFFDAB9), controller, context),
                _buildColorOption(const Color(0xFFD4B9DA), controller, context),
                _buildColorOption(const Color(0xFFFAEBD7), controller, context),
                _buildColorOption(const Color(0xFFF0E68C), controller, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorOption(
      Color color, NoteController controller, BuildContext sheetContext) {
    return GestureDetector(
      onTap: () {
        controller.selectedColor.value = color.value;
        Navigator.pop(sheetContext);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
