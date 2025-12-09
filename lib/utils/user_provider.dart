import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _forceMode = false;
  bool _isReady = false;
  bool _isLoggedIn = false;

  UserProvider() {
    _initAuth();
  }

  String? get username => _username;
  bool get forceMode => _forceMode;
  bool get isReady => _isReady;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> _initAuth() async {
    await _loadPreferences();

    final token = html.window.localStorage['jwt'];
    if (token == null) {
      _finish();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("http://localhost:8000/auth/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _username = data["name"] ?? data["email"];
        _isLoggedIn = true;
        await _savePreferences();
      } else {
        logout();
      }
    } catch (_) {
      logout();
    }

    _finish();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _forceMode = prefs.getBool('forceMode') ?? false;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_username != null) {
      await prefs.setString('username', _username!);
    }
    await prefs.setBool('forceMode', _forceMode);
  }

  void _finish() {
    _isReady = true;
    notifyListeners();
  }

  Future<void> toggleForceMode(bool value) async {
    _forceMode = value;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> setUsername(String value) async {
    _username = value.trim();
    await _savePreferences();
    notifyListeners();
  }

  Future<void> logout() async {
    html.window.localStorage.remove('jwt');
    _username = null;
    _isLoggedIn = false;
    await _savePreferences();
    notifyListeners();
  }
}