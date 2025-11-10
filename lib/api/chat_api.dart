import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatApi {
  static const _apiUrl = "https://api.openai.com/v1/chat/completions";
  static final _apiKey = dotenv.env['OPENAI_API_KEY'];

  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-5-mini",
        "messages": [
          {"role": "system", "content": ""
              "Du bist ein Chatbot der auf Aktien spezialisiert ist. "
              "Gib kurze und prägnante Antworten."
              "Du trifst die Entscheidung für den Nutzer."},
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception(
        "Fehler ${response.statusCode}: ${response.body}",
      );
    }
  }
}
