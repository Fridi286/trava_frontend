import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';
import '../utils/colors.dart';


class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        themeProvider.toggleTheme(value);
      },
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (themeProvider.isDarkMode) {
          return const Icon(
            Icons.dark_mode,
            color: AppColors.secondary,
          );
        }
        return const Icon(
          Icons.light_mode,
        ); // All other states will use the default thumbIcon.
      }
      ), 
      activeTrackColor: Color(0xFF1E3A5F),
      activeThumbColor: Color(0xFFD0E1F9),
      inactiveThumbColor: Color(0xFF5B4636),
      inactiveTrackColor: Color(0xFFB58B68),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (themeProvider.isDarkMode) {
          return Color(0xFFD0E1F9);
        }
        return Color(0xFF5B4636);
      }),
    );
  }
}
