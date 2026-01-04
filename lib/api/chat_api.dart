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

  Future<String> getPortfolioSummaryText() async {
  final uri = apiUrl('/api/alpaca/summary/text');

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer ${html.window.localStorage['jwt']}',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Portfolio konnte nicht geladen werden');
  }

  final data = jsonDecode(response.body);
  return data['message'] as String;
}

Future<String> requestPortfolioInsight() async {
    final portfolioSummary = await getPortfolioSummaryText();
    final prompt = '''
Hier ist mein aktuelles Portfolio in zusammengefasster Form:

$portfolioSummary

Aufgabe:
- anylsiere alle aktien aus meinem portfolio und gib mir eine zusammenfassung ob du etwas verkaufen halten oder beobachten würdest. 
  z.B. 3 deiner aktien würde ich verkaufen 2 halten
- Entsprechend des Geldes was ich zur Verfügung habe überleg dir aktien die du empfehlen kannst z.B: "Mit dem verfügbaren Guthaben könntest du in den bereich investieren"
- Berücksichtige dabei aktuelle Markttrends und Nachrichten
- Alles muss von dir später begründet werden können
- Mach mir gegliederter Stichpunkte mit überschriften
''';
    return await sendMessage(prompt);
}

  Future<Map<String, dynamic>> getStockHistory(
  String symbol, {
  String timeframe = '1Hour',
  String period = '1W',
}) async {
  final uri = apiUrl(
  '/api/market/stock/$symbol'
  '?period=$period',
);

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer ${html.window.localStorage['jwt']}',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Kursdaten konnten nicht geladen werden');
  }

  return jsonDecode(response.body);
}

}