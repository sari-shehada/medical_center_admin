import '../core/exceptions/not_found_exception.dart';
import '../core/services/http_service.dart';
import '../core/services/shared_prefs_service.dart';
import '../models/admin_info.dart';
import '../pages/navigation_controller.dart';

class AccountManager {
  AccountManager._({
    this.user,
    required this.isLoggedIn,
  });

  AdminInfo? user;
  bool isLoggedIn;

  static late AccountManager instance;

  static Future<AccountManager> init() async {
    try {
      final int? userId = _getUserIdFromLocalStorage();
      if (userId == null) {
        instance = AccountManager._(user: null, isLoggedIn: false);
        return instance;
      }
      final AdminInfo user = await _getAdminInfo(userId);
      instance = AccountManager._(user: user, isLoggedIn: true);
      return instance;
    } on NotFoundException catch (_) {
      instance = AccountManager._(user: null, isLoggedIn: false);
      return instance;
    }
  }

  Future<void> login(AdminInfo userInfo) async {
    await _saveUserIdToLocalStorage(userInfo.id);
    user = userInfo;
    isLoggedIn = true;
  }

  static Future<AdminInfo> _getAdminInfo(int id) async {
    return await HttpService.parsedGet(
      endPoint: 'admins/$id/',
      mapper: AdminInfo.fromJson,
    );
  }

  static int? _getUserIdFromLocalStorage() {
    return SharedPreferencesService.instance.getInt('adminId');
  }

  static Future<void> _saveUserIdToLocalStorage(int id) async {
    await SharedPreferencesService.instance.setInt(
      key: 'adminId',
      value: id,
    );
  }

  Future<void> logOut() async {
    await SharedPreferencesService.instance.removeKey(
      key: 'adminId',
    );
    user = null;
    isLoggedIn = false;
    NavigationController.toLoginPage();
  }
}
