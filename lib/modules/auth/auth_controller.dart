import 'package:get/get.dart';
import '../../data/models/user.dart';
import '../../data/services/storage_service.dart';
import 'auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepo _repo = AuthRepo();
  final StorageService _storage = StorageService();

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool loading = false.obs;

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.role == 'admin';

  Future<void> login(String email, String password) async {
    loading.value = true;
    final res = await _repo.login(email, password);
    loading.value = false;
    if (res['status'] == true) {
      // expected res['data'] contains user profile and token
      final data = res['data'];
      final user = User.fromJson(data['user'] ?? data);
      currentUser.value = user;
      _storage.saveMap('user', user.toJson());
      // token save if provided
      if (data['token'] != null) {
        _storage.saveString('token', data['token']);
      }
      // redirect based on role
      if (isAdmin) {
        Get.offAllNamed('/admin/dashboard');
      } else {
        Get.offAllNamed('/user/dashboard');
      }
    } else {
      Get.snackbar('Error', res['message'] ?? 'Login failed');
    }
  }

  void loadFromStorage() {
    final map = _storage.readMap('user');
    if (map != null) currentUser.value = User.fromJson(map);
  }

  void logout() {
    _storage.remove('user');
    _storage.remove('token');
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
