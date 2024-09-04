import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: const Color.fromARGB(83, 255, 255, 255),
    colorText: Colors.black,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    duration: const Duration(seconds: 2),
  );
}
