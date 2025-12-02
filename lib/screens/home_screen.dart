import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trava_frontend/widgets/basic_chat.dart';
import 'package:trava_frontend/widgets/dark_mode_switch.dart';
import 'package:trava_frontend/widgets/all_stocks_preview.dart';

import '../utils/user_provider.dart';
import '../theme/colors.dart';
import 'login_screen.dart';

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
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProvider.username == null || userProvider.username!.isEmpty) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRAVA'),
        actions: const [
          DarkModeSwitch(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF131C31), Color(0xFF1C2A45)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 8,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: TravaColors.primary.withOpacity(0.15),
                        radius: 26,
                        child: Icon(Icons.person_outline, color: TravaColors.primary.shade400),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hallo, ${userProvider.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dein persönlicher Assistent steht bereit. Aktiviere den Force-Button, um ohne Rückfragen zu antworten.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: userProvider.forceDirective
                              ? TravaColors.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          foregroundColor: userProvider.forceDirective
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: userProvider.forceDirective ? 4 : 0,
                        ),
                        onPressed: () =>
                            userProvider.setForceDirective(!userProvider.forceDirective),
                        icon: Icon(userProvider.forceDirective
                            ? Icons.flash_on_rounded
                            : Icons.flashlight_on_outlined),
                        label: Text(userProvider.forceDirective
                            ? 'Force aktiv'
                            : 'Force aktivieren'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChatWidget(
                            key: _chatKey,
                            username: userProvider.username!,
                            forceDirective: userProvider.forceDirective,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                        elevation: 10,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
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
