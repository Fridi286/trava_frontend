import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trava_frontend/widgets/basic_chat.dart';
import 'package:trava_frontend/widgets/dark_mode_switch.dart';
import 'package:trava_frontend/widgets/all_stocks_preview.dart';

import '../utils/theme_provider.dart';
import '../theme/colors.dart';
import '../widgets/api_key_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ChatWidgetState> _chatKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRAVA'),
        actions: [
          ApiKeyButton(
            onApiKeyChanged: () {
              _chatKey.currentState
                  ?.loadApiKey(); // 👈 ruft Funktion im Chat auf
            },
          ),
          DarkModeSwitch(),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
                child: ChatWidget(key: _chatKey)
            ),

            Expanded(
              flex: 3,
              child: AllStocksPreview()
            ),
          ],
        ),
      ),
    );
  }
}
