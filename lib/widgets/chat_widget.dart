import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
  bool _chartLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (_welcomeMessageSent || userProvider.username == null) return;

      _welcomeMessageSent = true;

      final chatApi = TravaApi();
      String text;
      try {
        text = await chatApi.getPortfolioSummaryText();
      } catch (_) {
        text = 'Portfolio konnte nicht geladen werden.';
      }

      if (!mounted) return;

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

  // ===============================
  // AGENT → CHART HANDLING (INLINE)
  // ===============================
  Future<void> _handleAgentAction(Map<String, dynamic> action) async {
    if (action['type'] != 'SHOW_STOCK_CHART') return;
    if (_chartLoading) return;

    _chartLoading = true;

    final symbol = action['symbol'] as String;
    final period = action['period'] ?? '1W';

    final chatApi = TravaApi();

    try {
      final data = await chatApi.getStockHistory(
        symbol,
        period: period,
      );

      final points = (data['points'] as List?) ?? [];

      final spots = <FlSpot>[];
      for (int i = 0; i < points.length; i++) {
        final raw = points[i]['c'];

        double? y;
        if (raw is num) {
          y = raw.toDouble();
        } else if (raw is String) {
          y = double.tryParse(raw.replaceAll(',', '').trim());
        }

        if (y != null && y.isFinite) {
          spots.add(FlSpot(i.toDouble(), y));
        }
      }

      if (spots.length < 2 || !mounted) {
        _chartLoading = false;
        return;
      }

      _chatController.insertMessage(
        TextMessage(
          id: 'chart-${DateTime.now().millisecondsSinceEpoch}',
          authorId: 'ai_response',
          createdAt: DateTime.now().toUtc(),
          text: '$symbol – Kursverlauf ($period)',
          metadata: {
            'chart': {
              'spots': spots,
            },
          },
        ),
      );
    } finally {
      _chartLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final chatTheme =
        themeProvider.isDarkMode ? ChatTheme.dark() : ChatTheme.light();

    final chatApi = TravaApi();
    final currentUserName = userProvider.username ?? 'Du';
    final currentUserId = currentUserName;

    return Chat(
      theme: chatTheme,
      chatController: _chatController,
      currentUserId: currentUserId,

      // ===============================
      // CUSTOM MESSAGE BUILDER (CHART)
      // ===============================
      customMessageBuilder: (message, {required int messageWidth}) {
        if (message is! TextMessage) return null;

        final chart = message.metadata?['chart'];
        if (chart == null) return null;

        final spots = (chart['spots'] as List).cast<FlSpot>();
        if (spots.length < 2) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Zu wenig Daten für Chart'),
          );
        }

        final ys = spots.map((e) => e.y).toList();
        final minY = ys.reduce((a, b) => a < b ? a : b);
        final maxY = ys.reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 220,
            width: messageWidth.toDouble(),
            child: LineChart(
              LineChartData(
                minY: minY == maxY ? minY * 0.99 : minY * 0.995,
                maxY: minY == maxY ? maxY * 1.01 : maxY * 1.005,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        );
      },

      onMessageSend: (text) async {
        var messageForApi = '$text\n\nsend by Username: $currentUserName';

        _chatController.insertMessage(
          TextMessage(
            id: '${++_messageId}',
            authorId: currentUserId,
            createdAt: DateTime.now().toUtc(),
            text: text,
          ),
        );

        final placeholder = TextMessage(
          id: 'temp-$_messageId',
          authorId: 'ai_response',
          createdAt: DateTime.now().toUtc(),
          text: '…',
        );
        _chatController.insertMessage(placeholder);

        try {
          final reply = await chatApi.sendMessage(messageForApi);

          try {
            final action = jsonDecode(reply);
            if (action is Map<String, dynamic> &&
                action['type'] == 'SHOW_STOCK_CHART') {
              _chatController.updateMessage(
                placeholder,
                TextMessage(
                  id: '${-_messageId}',
                  authorId: 'ai_response',
                  createdAt: DateTime.now().toUtc(),
                  text: '📈 Kursverlauf:',
                ),
              );

              await _handleAgentAction(action);
              return;
            }
          } catch (_) {}

          _chatController.updateMessage(
            placeholder,
            TextMessage(
              id: '${-_messageId}',
              authorId: 'ai_response',
              createdAt: DateTime.now().toUtc(),
