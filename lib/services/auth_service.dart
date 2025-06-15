import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final user = await DatabaseService.getUser(username);
    if (user != null && user['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> register(String username, String password) async {
    final existingUser = await DatabaseService.getUser(username);
    if (existingUser != null) {
      return false;
    }

    final success = await DatabaseService.createUser(username, password);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
    }
    return success;
  }
}
