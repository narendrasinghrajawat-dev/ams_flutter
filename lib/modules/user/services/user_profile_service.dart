

import '../../common/services/api_service.dart';
import '../../models/user.dart';

class UserProfileService {
  final ApiService _api = ApiService();

  Future<User?> fetchProfile() async {
    // TODO: Implement when backend is ready
    // final resp = await _api.get('/user/profile');
    // return User.fromJson(resp);
    return null;
  }

  Future<bool> updateProfile(User user) async {
    // TODO: Implement when backend is ready
    // await _api.put('/user/profile', user.toJson());
    return true;
  }
}
