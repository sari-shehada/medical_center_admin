import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SnackBarService {
  static Future<void> showNeutralSnackbar(
    String message, {
    Color backColor = const Color(0xFF303030),
    Widget? icon,
    Duration? duration,
  }) async {
    Get.rawSnackbar(
      icon: icon,
      message: message,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: backColor,
      duration: duration ?? 2.5.seconds,
    );
  }

  static Future<void> showErrorSnackbar(
    String message, {
    Duration? duration,
  }) async {
    await showNeutralSnackbar(
      message,
      backColor: Get.theme.colorScheme.error,
      duration: duration,
    );
  }

  static Future<void> showSuccessSnackbar(
    String message, {
    Duration? duration,
  }) async {
    await showNeutralSnackbar(
      message,
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
      backColor: Colors.lightGreen.shade800,
      duration: duration,
    );
  }
}
