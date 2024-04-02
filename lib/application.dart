import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'config/string_constants.dart';
import 'config/theme/app_theme.dart';
import 'pages/loader_page/loader_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      useInheritedMediaQuery: true,
      designSize: const Size(1920, 1080),
      builder: (context, child) {
        return GetMaterialApp(
          theme: lightTheme,
          title: StringConstants.appName,
          home: const LoaderPage(),
          locale: const Locale('ar'),
        );
      },
    );
  }
}
