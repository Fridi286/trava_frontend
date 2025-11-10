import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';

import '../api/chat_api.dart';
import '../models/theme_provider.dart';

class Basic extends StatefulWidget {
  const Basic({super.key});

  @override
  BasicState createState() => BasicState();
}

class BasicState extends State<Basic> {
  final _chatController = InMemoryChatController();
  
  int message_id = 0;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final chatTheme = isDarkMode
        ? ChatTheme.dark()
        : ChatTheme.light();
    return Scaffold(
      body: Chat(
        theme: chatTheme,
        chatController: _chatController,
        currentUserId: 'user1',
        onMessageSend: (text) async {
          _chatController.insertMessage(
            TextMessage(
              // Better to use UUID or similar for the ID - IDs must be unique
              id: '${++message_id}',
              authorId: 'user1',
              createdAt: DateTime.now().toUtc(),
              text: text,
            ),
          );
          _chatController.insertMessage(
            TextMessage(
              id: '${-(message_id)}',
              authorId: 'ai_response',
              createdAt: DateTime.now().toUtc(),
              text: "...",
            ),
          );
          _chatController.updateMessage(
              TextMessage(
                id: '${-message_id}',
                authorId: 'user1',
                  text: ''
              ),
              TextMessage(
                id: '${-(++message_id)}',
                authorId: 'ai_response',
                text: await ChatApi.sendMessage(text),
              )
          );
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: 'Nutzer');
        },
      ),
    );
  }
}