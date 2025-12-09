import 'dart:html' as html;
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final String? token;
  const AuthScreen({super.key, this.token});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();

    final token = widget.token;

    if (token != null && token.isNotEmpty) {
      html.window.localStorage['jwt'] = token;

      // Token aus URL-Struktur entfernen
      html.window.history.replaceState(null, '', '/');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}