import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> goTo(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  Future<dynamic> goToWithParams(String routeName, Map<String, dynamic> params) {
    final uri = Uri(
      path: routeName,
      queryParameters: params.map((key, value) => MapEntry(key, value.toString())),
    ).toString();
    return navigatorKey.currentState!.pushNamed(uri, arguments: params);
  }

  Future<dynamic> goToAndReplace(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: args);
  }

  Future<dynamic> goToAndReplaceWithParams(String routeName, Map<String, dynamic> params) {
    final uri = Uri(
      path: routeName,
      queryParameters: params.map((key, value) => MapEntry(key, value.toString())),
    ).toString();
    return navigatorKey.currentState!.pushReplacementNamed(uri, arguments: params);
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }

  void goToHome() {
    navigatorKey.currentState!.pushNamedAndRemoveUntil('/', (route) => false);
  }
} 