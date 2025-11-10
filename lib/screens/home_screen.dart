import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trava_frontend/widgets/basic_chat.dart';
import 'package:trava_frontend/widgets/dark_mode_switch.dart';

import '../models/theme_provider.dart';
import '../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRAVA'),
        actions: [
          DarkModeSwitch()
        ],
      ),
      body: Center(
        child: Basic()
      ),
    );
  }
}