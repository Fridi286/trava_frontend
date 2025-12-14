import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

import '../config.dart';

class TravaApi {
  // API Base ist build-time konfigurierbar via --dart-define=API_BASE_URL=...
  static final Uri _replyMasterUrl = apiUrl('/api/reply/master');

  Future<String> sendMessage(String message) async {
    final token = html.window.localStorage['jwt'];

    if (token == null) {
      html.window.location.href = "/#/login";
      return "Nicht eingeloggt.";
    }

    try {
      final response = await http.post(
        _replyMasterUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"query": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["response"] ?? "Keine Antwort erhalten.";
      } else if (response.statusCode == 401) {
        html.window.localStorage.remove('jwt');
        html.window.location.href = "/#/login";
        return "Session abgelaufen. Bitte erneut einloggen.";
      } else {
        // Response ist nicht garantiert JSON
        try {
          final error = jsonDecode(response.body);
          final errorMsg = error["error"]?["message"] ?? response.body;
          return "Fehler ${response.statusCode}: $errorMsg";
        } catch (_) {
          return "Fehler ${response.statusCode}: ${response.body}";
        }
      }
    } catch (e) {
      return "Anfrage fehlgeschlagen: $e";
    }
  }
}
