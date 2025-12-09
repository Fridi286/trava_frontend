import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class TravaApi {
  static const _apiUrl = "http://localhost:8000/reply/master";

  Future<String> sendMessage(String message) async {
    final token = html.window.localStorage['jwt'];

    if (token == null) {
      // Nutzer ausgeloggt
      html.window.location.href = "/#/login";
      return "Nicht eingeloggt.";
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "query": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["response"] ?? "Keine Antwort erhalten.";
      } else if (response.statusCode == 401) {
        html.window.localStorage.remove('jwt');
        html.window.location.href = "/#/login";
        return "Session abgelaufen. Bitte erneut einloggen.";
      } else {
        final error = jsonDecode(response.body);
        final errorMsg = error["error"]?["message"] ?? response.body;
        return "Fehler ${response.statusCode}: $errorMsg";
      }
    } catch (e) {
      return "Anfrage fehlgeschlagen: $e";
    }
  }
}