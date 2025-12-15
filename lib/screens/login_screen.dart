import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            html.window.location.href = "${apiBaseUrl}/auth/login";
          },
          child: const Text("Login via GitLab"),
        ),
      ),
    );
  }
}
