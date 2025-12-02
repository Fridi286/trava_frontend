import 'dart:convert';
import 'package:http/http.dart' as http;

class TravaApi {
  static const _apiUrl = "http://127.0.0.1:8000/reply/master";

  Future<String> sendMessage(
    String message, {
    required String username,
    required bool forceDirective,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": message,
          "metadata": {
            "username": username,
            "forceDirective": forceDirective,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["response"] ?? "Keine Antwort erhalten.";
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
