import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyButton extends StatelessWidget {
  final VoidCallback? onApiKeyChanged;

  const ApiKeyButton({super.key, this.onApiKeyChanged});

  Future<void> _showApiKeyDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final prefs = await SharedPreferences.getInstance();

    final savedKey = prefs.getString('openai_api_key');
    if (savedKey != null) controller.text = savedKey;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('OpenAI API-Key eingeben'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'API Key',
              hintText: 'sk-...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                final key = controller.text.trim();
                if (key.isNotEmpty) {
                  await prefs.setString('openai_api_key', key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('API Key gespeichert ')),
                  );
                  Navigator.pop(context);
                  if (onApiKeyChanged != null) onApiKeyChanged!(); //  Trigger
                }
              },
              child: const Text('Speichern und Neu Laden'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.vpn_key),
      tooltip: 'OpenAI API-Key eingeben',
      onPressed: () => _showApiKeyDialog(context),
    );
  }
}