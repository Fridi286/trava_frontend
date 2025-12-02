import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _forceDirective = false;
  bool _isInitialized = false;

  UserProvider() {
    _loadUser();
  }

  String? get username => _username;
  bool get forceDirective => _forceDirective;
  bool get isInitialized => _isInitialized;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _forceDirective = prefs.getBool('forceDirective') ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }

  Future<void> setForceDirective(bool value) async {
    _forceDirective = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('forceDirective', value);
    notifyListeners();
  }
}
