import 'dart:convert';
import 'package:http/http.dart' as http;

class TravaApi {
  static const _apiUrl = "http://127.0.0.1:8000/ai/news";

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "query": message,
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

class ChatApi {
  String apiKey;
  static const _apiUrl = "https://api.openai.com/v1/chat/completions";

  ChatApi({required this.apiKey});

  void setApiKey(String key) {
    apiKey = key;
  }


  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-5-mini",
          "messages": [
            {
              "role": "system",
              "content":
              "Du bist ein Chatbot, der auf Aktien spezialisiert ist. "
                  "Gib kurze und prägnante Antworten. "
                  "Triff Entscheidungen für den Nutzer."
            },
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"] ?? "Keine Antwort erhalten.";
      } else {
        // OpenAI-Fehler oder ungültiger Key
        final error = jsonDecode(response.body);
        final errorMsg = error["error"]?["message"] ?? response.body;
        return "Fehler ${response.statusCode}: $errorMsg";
      }
    } catch (e) {
      // z. B. kein Internet oder JSON-Parsing-Fehler
      return "Anfrage fehlgeschlagen: $e";
    }
  }
}
