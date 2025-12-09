import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/auth_screen.dart';

import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'utils/theme_provider.dart';
import 'utils/user_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TRAVA Assistant',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      routes: {
        '/': (context) => const _AppEntryPoint(),
        '/login': (context) => const LoginScreen(),
        '/auth': (context) => const AuthScreen(),
      },
      initialRoute: '/',
    );
  }
}

class _AppEntryPoint extends StatefulWidget {
  const _AppEntryPoint();

  @override
  State<_AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<_AppEntryPoint> {
  @override
  void initState() {
    super.initState();

    // Token aus Redirect (#/auth?token=XYZ)
    final uri = Uri.parse(html.window.location.href);
    final token = uri.queryParameters['token'];

    if (token != null) {
      html.window.localStorage['jwt'] = token;

      // Entfernt das Token optisch aus der URL
      html.window.history.replaceState(null, '', '/');
    }

    // Danach User Lade-Vorgang starten
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (!userProvider.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!userProvider.isLoggedIn) {
          return const LoginScreen();
        }

        return const ChatScreen(title: 'Your Personal Assistant');
      },
    );
  }
}