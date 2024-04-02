import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_admin/application.dart';
import 'package:medical_center_admin/core/services/shared_prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  await ScreenUtil.ensureScreenSize();
  runApp(const Application());
}
