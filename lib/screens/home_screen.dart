import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trava_frontend/widgets/chat_widget.dart';
import 'package:trava_frontend/widgets/dark_mode_switch.dart';
import 'package:trava_frontend/widgets/all_stocks_preview.dart';

import '../utils/theme_provider.dart';
import '../utils/user_provider.dart';
import '../theme/colors.dart';

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
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username ?? 'Gast';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Colors.white),
            const SizedBox(width: 8),
            const Text('TRAVA'),
            const SizedBox(width: 8),
            Chip(
              label: Text(
                username,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              const Text('Force'),
              Switch(
                activeColor: AppColors.accent,
                value: userProvider.forceMode,
                onChanged: (value) =>
                    Provider.of<UserProvider>(context, listen: false)
                        .toggleForceMode(value),
              ),
            ],
          ),
          DarkModeSwitch(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E1F2F), Color(0xFF0B2738), Color(0xFF0A1929)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hallo $username',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Stelle deine Fragen oder hol dir Marktupdates.',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            userProvider.forceMode
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: userProvider.forceMode
                                ? AppColors.success
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            userProvider.forceMode
                                ? 'Keine Nachfragen'
                                : 'Standard',
                            style: TextStyle(
                              color: userProvider.forceMode
                                  ? AppColors.success
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Card(
                        color: themeProvider.isDarkMode
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ChatWidget(key: _chatKey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AllStocksPreview(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
