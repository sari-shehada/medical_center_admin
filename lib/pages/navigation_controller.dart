import 'package:get/get.dart';
import 'package:medical_center_admin/pages/dashboard/dashboard.dart';
import 'package:medical_center_admin/pages/loader_page/loader_page.dart';
import 'package:medical_center_admin/pages/login_page/login_page.dart';

abstract class NavigationController {
  static Future<void> toLoginPage({
    bool offAll = true,
  }) async {
    Get.offAll(
      () => const LoginPage(),
    );
  }

  static Future<void> toLoaderPage() async {
    Get.offAll(
      () => const LoaderPage(),
    );
  }

  static void toDashboard() {
    Get.offAll(
      () => const Dashboard(),
    );
  }
}
