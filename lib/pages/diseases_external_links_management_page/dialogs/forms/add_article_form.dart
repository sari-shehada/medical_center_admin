import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_center_admin/pages/medicine_management_page/add_medicine_dialog/forms/add_medicine_form.dart';

class AddArticleForm {
  AddArticleForm({
    required this.diseaseId,
  });
  final int diseaseId;
  TextEditingController titleController = TextEditingController();
  TextEditingController briefController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  File? imageFile;
  String? fileExtension;

  Future<bool> pickArticleImage() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePickerResult == null) {
      return false;
    }
    var file = filePickerResult.files.first;
    if (kIsWeb) {
      imageFile = File.fromRawPath(file.bytes!);
    } else {
      imageFile = File(file.path!);
    }
    fileExtension = file.extension;

    return true;
  }

  String? validateForm() {
    if (titleController.text.isEmpty ||
        briefController.text.isEmpty ||
        linkController.text.isEmpty) {
      return 'يرجى ملء جميع الحقول للمتابعة';
    }
    if (imageFile == null) {
      return 'يرجى اختيار صورة للمقال';
    }
    return null;
  }

  Future<FormData> toFormData() async {
    var imageName = RandomStringGen.generateRandomNumberCombination();
    return FormData.fromMap(
      {
        'title': titleController.text,
        'brief': briefController.text,
        'link': linkController.text,
        'diseaseId': diseaseId,
        'imageUrl': MultipartFile.fromBytes(
          await imageFile!.readAsBytes(),
          filename: '$imageName.$fileExtension',
        ),
      },
    );
  }
}
