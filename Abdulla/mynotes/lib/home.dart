import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynotes/task_controller.dart';
import 'package:mynotes/second_home.dart';

class Home1 extends StatelessWidget {
  Home1({super.key});
  final TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 12, bottom: 20),
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'Notes App',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 30,
                    color: Colors.black,
                  ))
            ],
          ),
          Expanded(
            child: Obx(
              () {
                if (taskController.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sticky_note_2_sharp,
                            color: Colors.yellow[700], size: 100),
                        const SizedBox(height: 20),
                        const Text(
                          'No Notes available!',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: taskController.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskController.tasks[index];
                      return Card(
                        color: Color(task.color), 
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(task.subtitle),
                          onTap: () {
                            Get.to(() => Secondhome(task: task, index: index));
                          },
                          onLongPress: () {
                            taskController.onTaskLongPress(index);
                            _showDeleteBottomSheet(context);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.yellow[700],
              onPressed: () {
                Get.to(() => Secondhome());
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(120))),
              child: const Icon(Icons.add, color: Colors.white, size: 40),
            ),
          )
        ],
      ),
    )));
  }

  void _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 120, right: 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete this Note?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (taskController.selectedIndex.value >= 0) {
                    taskController
                        .deleteTask(taskController.selectedIndex.value);
                    taskController.clearSelectedIndex();
                  }
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
