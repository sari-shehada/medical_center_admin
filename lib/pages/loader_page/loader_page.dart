import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_admin/core/ui_utils/app_logo_widget.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/managers/account_manager.dart';

import '../../config/string_constants.dart';
import '../navigation_controller.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _performInitialLoading();
      },
    );
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogoWidget(
              size: 280.sp,
            ),
            AddVerticalSpacing(
              value: 100.h,
            ),
            Text(
              StringConstants.appName,
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.grey.shade800,
              ),
            ),
            AddVerticalSpacing(value: 30.h),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .15,
              child: const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performInitialLoading() async {
    await AccountManager.init();
    if (!AccountManager.instance.isLoggedIn) {
      NavigationController.toLoginPage();
      return;
    }
    NavigationController.toDashboard();
  }
}
