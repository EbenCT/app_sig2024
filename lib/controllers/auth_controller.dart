import '../services/api_service.dart';
import '../models/user.dart';

class AuthController {
  final ApiService apiService;

  AuthController(this.apiService);

  Future<User> login(String username, String password) async {
    final data = await apiService.login(username, password);
    return User.fromJson(data);
  }
}
