import 'package:flutter/material.dart';
import 'package:mark/screens/home_screen.dart';
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
      initialRoute: HomeScreen.route,
      onGenerateRoute: Routes.onGenerateRoute,
      onUnknownRoute: Routes.onUnknownRoute,
    );
  }
}
