import 'package:flutter/material.dart';
import 'screens/math_game_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MathApp());
}

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Математика для дітей',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MathGameScreen(),
    );
  }
}
