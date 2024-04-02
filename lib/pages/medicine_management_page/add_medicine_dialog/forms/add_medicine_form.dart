import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddMedicineForm {
  TextEditingController nameController = TextEditingController();
  Uint8List? imageBytes;

  Future<bool> pickMedicineImage() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePickerResult == null) {
      return false;
    }
    imageBytes = filePickerResult.files.first.bytes;
    return true;
  }
}
