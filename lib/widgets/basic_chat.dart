import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';

import '../api/chat_api.dart';
import '../utils/theme_provider.dart';
import '../utils/user_provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  final InMemoryChatController _chatController = InMemoryChatController();
  int _messageId = 0;
  bool _welcomeMessageSent = false;

  @override
  void initState() {
    super.initState();

    /// WICHTIG:
    /// Nachricht erst NACH dem ersten Layout einfügen,
    /// sonst Flutter-Web-Crash (RenderBox / history state)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false);

      if (_welcomeMessageSent) return;
      if (userProvider.username == null) return;

      _welcomeMessageSent = true;

      final chatApi = TravaApi();

      String text;
      try {
        text = await chatApi.getPortfolioSummaryText(
          userProvider.username!,
        );
      } catch (_) {
        text = 'Portfolio konnte nicht geladen werden.';
      }

      _chatController.insertMessage(
        TextMessage(
          id: 'welcome',
          authorId: 'ai_response',
          createdAt: DateTime.now().toUtc(),
          text: text,
        ),
      );
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final chatTheme =
        themeProvider.isDarkMode ? ChatTheme.dark() : ChatTheme.light();

    final chatApi = TravaApi();

    final currentUserName = userProvider.username ?? "Du";
    final currentUserId = currentUserName;

    return Chat(
      theme: chatTheme,
      chatController: _chatController,
      currentUserId: currentUserId,

      onMessageSend: (text) async {
        var messageForApi = '$text\n\nsend by Username: $currentUserName';

        if (userProvider.forceMode) {
          messageForApi +=
              '\n\nstelle keine unnötigen Rückfragen, entscheide selbstständig';
        }

        final userMessage = TextMessage(
          id: '${++_messageId}',
          authorId: currentUserId,
          createdAt: DateTime.now().toUtc(),
          text: text,
        );
        _chatController.insertMessage(userMessage);

        final placeholder = TextMessage(
          id: 'temp-$_messageId',
          authorId: 'ai_response',
          createdAt: DateTime.now().toUtc(),
          text: '…',
        );
        _chatController.insertMessage(placeholder);

        try {
          final reply = await chatApi.sendMessage(messageForApi);

          _chatController.updateMessage(
            placeholder,
            TextMessage(
              id: '${-_messageId}',
              authorId: 'ai_response',
              createdAt: DateTime.now().toUtc(),
              text: reply,
            ),
          );
        } catch (_) {
          _chatController.updateMessage(
            placeholder,
            TextMessage(
              id: '${-_messageId}',
              authorId: 'ai_response',
              createdAt: DateTime.now().toUtc(),
              text: 'Fehler beim Senden der Nachricht.',
            ),
          );
        }
      },

      resolveUser: (UserID id) async {
        return User(
          id: id,
          name: id == currentUserId ? currentUserName : "TRAVA",
        );
      },
    );
  }
}