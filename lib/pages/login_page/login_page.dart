import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_admin/core/services/http_service.dart';
import 'package:medical_center_admin/core/services/snackbar_service.dart';
import 'package:medical_center_admin/core/ui_utils/app_logo_widget.dart';
import 'package:medical_center_admin/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_admin/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_admin/core/ui_utils/text_fields/custom_text_field.dart';
import 'package:medical_center_admin/managers/account_manager.dart';
import 'package:medical_center_admin/models/admin_info.dart';
import 'package:medical_center_admin/pages/login_page/models/login_form.dart';
import 'package:medical_center_admin/pages/navigation_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<CustomButtonStatus> loginButtonStatus = CustomButtonStatus.enabled.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
            // height: MediaQuery.sizeOf(context).height * .4,
            width: MediaQuery.sizeOf(context).width * .35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogoWidget(
                  size: 240.sp,
                ),
                AddVerticalSpacing(value: 20.h),
                Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 19.sp,
                  ),
                ),
                AddVerticalSpacing(value: 35.h),
                CustomTextField(
                  controller: usernameController,
                  label: 'اسم المستخدم',
                ),
                AddVerticalSpacing(value: 10.h),
                CustomTextField(
                  controller: passwordController,
                  label: 'كلمة المرور',
                  obscureText: true,
                ),
                AddVerticalSpacing(value: 20.h),
                CustomFilledButton(
                  onTap: () => login(),
                  buttonStatus: loginButtonStatus,
                  child: 'تسجيل الدخول',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    LoginForm loginForm = LoginForm(
      username: usernameController.text,
      password: passwordController.text,
    );
    String? validationMessage = loginForm.validateForm();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    try {
      loginButtonStatus.value = CustomButtonStatus.processing;
      String requestResult = await HttpService.rawPost(
        endPoint: 'admins/login/',
        body: loginForm.toMap(),
      );
      var decodedResult = jsonDecode(requestResult);
      if (decodedResult == false) {
        SnackBarService.showErrorSnackbar('معلومات تسجيل دخول غير صحيحة');
        return;
      }
      AdminInfo userInfo = AdminInfo.fromMap(decodedResult);
      AccountManager.instance.login(userInfo);
      NavigationController.toDashboard();
    } finally {
      loginButtonStatus.value = CustomButtonStatus.enabled;
    }
  }
}
