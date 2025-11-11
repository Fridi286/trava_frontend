import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/chat_api.dart';
import '../utils/test_api_key.dart';
import '../utils/theme_provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  final _chatController = InMemoryChatController(

  );
  int messageId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final chatTheme =
    themeProvider.isDarkMode ? ChatTheme.dark() : ChatTheme.light();


    final chatApi = TravaApi();

    return Chat(
      decoration: BoxDecoration(
      ),
      theme: chatTheme,
      chatController: _chatController,
      currentUserId: 'user1',
      onMessageSend: (text) async {
        _chatController.insertMessage(
          TextMessage(
            id: '${++messageId}',
            authorId: 'user1',
            createdAt: DateTime.now().toUtc(),
            text: text,
          ),
        );

        final placeholder = TextMessage(
          id: 'temp-$messageId',
          authorId: 'ai_response',
          createdAt: DateTime.now().toUtc(),
          text: "...",
        );
        _chatController.insertMessage(placeholder);

        final reply = await chatApi.sendMessage(text);

        _chatController.updateMessage(
          placeholder,
          TextMessage(
            id: '${-(messageId)}',
            authorId: 'ai_response',
            createdAt: DateTime.now().toUtc(),
            text: reply,
          ),
        );
      },
      resolveUser: (UserID id) async {
        return User(id: id, name: id == 'user1' ? 'Du' : 'TRAVA');
      },
    );
  }
}
