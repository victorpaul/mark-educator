import 'package:flutter/material.dart';

class DifficultyLevel {
  final String name;
  final String emoji;
  final Color color;
  final int minNumber;
  final int maxNumber;
  final int maxSum;

  const DifficultyLevel({
    required this.name,
    required this.emoji,
    required this.color,
    required this.minNumber,
    required this.maxNumber,
    required this.maxSum,
  });
}

class DifficultyConfig {
  static const List<DifficultyLevel> levels = [
    DifficultyLevel(
      name: '1-4',
      emoji: '🌱',
      color: Colors.green,
      minNumber: 1,
      maxNumber: 4,
      maxSum: 5,
    ),
    DifficultyLevel(
      name: '1-7',
      emoji: '🌟',
      color: Colors.orange,
      minNumber: 1,
      maxNumber: 7,
      maxSum: 9,
    ),
    DifficultyLevel(
      name: 'Складний',
      emoji: '🔥',
      color: Colors.red,
      minNumber: 1-9,
      maxNumber: 9,
      maxSum: 10,
    ),
    // DifficultyLevel(
    //   name: 'Експерт',
    //   emoji: '🏆',
    //   color: Colors.purple,
    //   minNumber: 1,
    //   maxNumber: 9,
    //   maxSum: 10,
    // ),
  ];
} 