import 'package:flutter/material.dart';
import '../screens/math_game_screen.dart';
import '../screens/congratulation_screen.dart';
import '../screens/home_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.route: (context) => const HomeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Розбираємо URL на шлях та параметри
    final uri = Uri.parse(settings.name ?? '');
    final params = settings.arguments as Map<String, dynamic>? ?? {};

    switch (uri.path) {
      case MathGameScreen.route:
        return _buildRoute(
          settings,
          MathGameScreen(
            initialOperation: params['initialOperation'] as String?,
            difficultyIndex: params['difficultyIndex'] != null
                ? int.parse(params['difficultyIndex'].toString())
                : null,
          ),
        );
      case CongratulationScreen.route:
        return _buildRoute(
            settings,
            CongratulationScreen(
              correctAnswers: params['correctAnswers'] as int,
              totalAnswers: params['totalAnswers'] as int,
            ));
      default:
        return _buildRoute(settings, const HomeScreen());
    }
  }

  static PageRouteBuilder _buildRoute(RouteSettings settings, Widget screen) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (ctx, a, sa, child) => child,
      transitionDuration: const Duration(seconds: 0),
      reverseTransitionDuration: const Duration(seconds: 0),
    );
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
  }
}
