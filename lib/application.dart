import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/config/string_constants.dart';
import 'package:medical_center_admin/pages/loader_page/loader_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      useInheritedMediaQuery: true,
      designSize: const Size(1080, 1920),
      builder: (context, child) {
        return const GetMaterialApp(
          title: StringConstants.appName,
          home: LoaderPage(),
        );
      },
    );
  }
}
