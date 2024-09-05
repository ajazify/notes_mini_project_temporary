import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mynotes/task.dart';

class TaskController extends GetxController {
  late Box<Task> taskBox;
  var tasks = <Task>[].obs;
  var selectedIndex = (-1).obs;
  bool isBoxOpen = false;

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future<void> openBox() async {
    taskBox = await Hive.openBox<Task>('tasks');
    tasks.assignAll(taskBox.values);
    isBoxOpen = true;
  }

  Future<void> addTask(String title, String subtitle,
      {Color color = Colors.white}) async {
    if (!isBoxOpen) {
      await openBox(); 
    }

    final task = Task(title: title, subtitle: subtitle, color: color.value);
    taskBox.add(task);
    tasks.add(task);
  }

  Future<void> updateTask(int index, String title, String subtitle,
      {Color color = Colors.white}) async {
    if (!isBoxOpen) {
      await openBox(); 
    }

    final updatedTask = Task(title: title, subtitle: subtitle, color: color.value);
    taskBox.putAt(index, updatedTask);
    tasks[index] = updatedTask;
  }

  Future<void> setTaskColor(int index, Color color) async {
    if (!isBoxOpen) {
      await openBox(); }

    final task = tasks[index];
    final updatedTask = Task(
        title: task.title, subtitle: task.subtitle, color: color.value);
    taskBox.putAt(index, updatedTask); 
    tasks[index] = updatedTask;
  }

  Future<void> deleteTask(int index) async {
    if (!isBoxOpen) {
      await openBox();  }

    taskBox.deleteAt(index);
    tasks.removeAt(index);
  }

  void onTaskLongPress(int index) {
    selectedIndex.value = index;
  }

  void clearSelectedIndex() {
    selectedIndex.value = -1;
  }
}

class TextFieldController extends GetxController {
  var subtitleController = TextEditingController().obs;
  var characterCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    subtitleController.value.addListener(() {
      characterCount.value = subtitleController.value.text.length;
    });
  }

  @override
  void onClose() {
    subtitleController.value.dispose();
    super.onClose();
  }
}
