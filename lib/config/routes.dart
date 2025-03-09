import 'package:flutter/material.dart';
import '../screens/math_game_screen.dart';
import '../screens/congratulation_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> get routes => {
    MathGameScreen.route: (context) => const MathGameScreen(),
    // Для екрану привітання потрібні аргументи, тому він буде оброблятися в onGenerateRoute
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CongratulationScreen.route:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => CongratulationScreen(
            correctAnswers: args['correctAnswers'],
            totalAnswers: args['totalAnswers'],
          ),
        );
      default:
        return null;
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const MathGameScreen(),
    );
  }
} 