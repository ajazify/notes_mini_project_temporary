import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/task.dart';
import 'package:mynotes/task_controller.dart';

class Secondhome extends StatelessWidget {
  final Task? task;
  final int? index;

  Secondhome({super.key, this.task, this.index});

  final String tdata = DateFormat("hh:mm a").format(DateTime.now());
  final String cdate2 = DateFormat("dd MMMM").format(DateTime.now());
  final TextFieldController textFieldController =
      Get.put(TextFieldController());
  final TextEditingController _titleController = TextEditingController();
  final TaskController taskController = Get.put(TaskController());

  final List<Color> _colorOptions = [
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
  ];

  Rx<Color> selectedColor = Colors.white.obs;

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      _titleController.text = task!.title;
      textFieldController.subtitleController.value.text = task!.subtitle;
      selectedColor.value = Color(task!.color); 
    }

    return Obx(() => Scaffold(
          backgroundColor: selectedColor.value,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: selectedColor.value,
                    actions: [
                      IconButton(
                        onPressed: () {
                          _titleController.clear();
                          textFieldController.subtitleController.value.clear();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showColorPicker(context);
                        },
                        icon: const Icon(
                          Icons.color_lens,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_titleController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Title cannot be empty',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (task != null && index != null) {
                            taskController.updateTask(
                              index!,
                              _titleController.text,
                              textFieldController.subtitleController.value.text,
                              color: selectedColor.value, 
                            );
                          } else {
                            taskController.addTask(
                              _titleController.text.trim(),
                              textFieldController.subtitleController.value.text,
                              color: selectedColor.value, 
                            );
                          }

                          _titleController.clear();
                          textFieldController.subtitleController.value.clear();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 24, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Text(
                          '$cdate2',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '$tdata   |',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Obx(
                            () => Text(
                              '${textFieldController.characterCount.value} Characters',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller:
                          textFieldController.subtitleController.value,
                      decoration: const InputDecoration(
                        hintText: 'Start typing',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _colorOptions.map((color) {
              return GestureDetector(
                onTap: () {
                  selectedColor.value = color;
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 30,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
