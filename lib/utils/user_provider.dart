import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _forceMode = false;
  bool _isReady = false;

  UserProvider() {
    _loadPreferences();
  }

  String? get username => _username;

  bool get forceMode => _forceMode;

  bool get isReady => _isReady;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _forceMode = prefs.getBool('forceMode') ?? false;
    _isReady = true;
    notifyListeners();
  }

  Future<void> setUsername(String value) async {
    _username = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username!);
    notifyListeners();
  }

  Future<void> toggleForceMode(bool value) async {
    _forceMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('forceMode', _forceMode);
    notifyListeners();
  }
}
