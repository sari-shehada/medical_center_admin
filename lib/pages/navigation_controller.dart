import 'package:get/get.dart';
import 'package:medical_center_admin/pages/loader_page/loader_page.dart';

abstract class NavigationController {
  static Future<void> toLoginPage({
    bool offAll = true,
  }) async {}

  static Future<void> toLoaderPage() async {
    Get.offAll(
      () => const LoaderPage(),
    );
  }
}
