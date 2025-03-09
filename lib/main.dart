import 'package:flutter/material.dart';
import 'services/navigation_service.dart';
import 'config/routes.dart';
import 'screens/math_game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return MaterialApp(
      title: 'Навчальні ігри',
      navigatorKey: navigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MathGameScreen.route,
      routes: Routes.routes,
      onGenerateRoute: Routes.onGenerateRoute,
      onUnknownRoute: Routes.onUnknownRoute,
    );
  }
}
