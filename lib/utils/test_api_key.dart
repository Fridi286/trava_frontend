import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> testApiKey(String apiKey) async {
  const url = "https://api.openai.com/v1/models";

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $apiKey",
    },
  );

  if (response.statusCode == 200) {
    print("API-Key funktioniert!");
    return true;
  } else {
    print("API-Key ungültig oder keine Verbindung (${response.statusCode})");
    print(response.body);
    return false;
  }
}
