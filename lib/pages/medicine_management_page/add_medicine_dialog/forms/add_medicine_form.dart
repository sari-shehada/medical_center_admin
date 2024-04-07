import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddMedicineForm {
  TextEditingController nameController = TextEditingController();
  Uint8List? imageBytes;
  String? fileExtension;
  Future<bool> pickMedicineImage() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePickerResult == null) {
      return false;
    }
    var file = filePickerResult.files.first;
    if (kIsWeb) {
      imageBytes = file.bytes!;
    } else {
      imageBytes = await File(file.path!).readAsBytes();
    }
    fileExtension = file.extension;
    return true;
  }

  String? validateForm() {
    if (nameController.text.isEmpty) {
      return 'يرجى ملء حقل اسم الدواء';
    }
    if (imageBytes == null) {
      return 'يرجى اختيار صورة للدواء';
    }
    return null;
  }

  Future<FormData> toFormData() async {
    var imageName = RandomStringGen.generateRandomNumberCombination();
    return FormData.fromMap(
      {
        'name': nameController.text,
        'imageUrl': MultipartFile.fromBytes(
          imageBytes!,
          filename: '$imageName.$fileExtension',
        ),
      },
    );
  }
}

class RandomStringGen {
  static String generateRandomNumberCombination({int length = 10}) {
    return List.generate(
      15,
      (index) => (Random().nextInt(10) + 48),
    ).join();
  }
}
