import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void goTo(String route, {dynamic args}) {
    navigatorKey.currentState?.pushNamed(route, arguments: args);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }

  void goToAndReplace(String route, {dynamic args}) {
    navigatorKey.currentState?.pushReplacementNamed(route, arguments: args);
  }

  void goToAndClearStack(String route, {dynamic args}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: args,
    );
  }
} 