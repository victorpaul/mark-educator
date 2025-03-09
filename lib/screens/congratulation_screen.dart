import 'package:flutter/material.dart';
import '../services/firework_service.dart';
import '../services/navigation_service.dart';
import '../theme/app_theme.dart';
import './math_game_screen.dart';

class CongratulationScreen extends StatelessWidget {
  static const String route = '/congratulation';
  
  final int correctAnswers;
  final int totalAnswers;

  const CongratulationScreen({
    super.key,
    required this.correctAnswers,
    required this.totalAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = (correctAnswers / totalAnswers * 100).round();
    final wrongAnswers = totalAnswers - correctAnswers;
    final _navigation = NavigationService();
    
    // Визначаємо кількість феєрверків залежно від точності
    final fireworkCount = accuracy >= 90 ? 5 : accuracy >= 70 ? 3 : 1;
    
    // Показуємо феєрверки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firework = FireworkService();
      for (var i = 0; i < fireworkCount; i++) {
        Future.delayed(Duration(seconds: i), () {
          firework.show(context);
        });
      }
    });

    return Container(
      color: Colors.blue.withOpacity(0.9),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка повернення на головну
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () => _navigation.goToHome(),
                  icon: const Icon(
                    Icons.home_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              '🎉 Вітаємо! 🎉',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ти молодець!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[300],
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Твої результати:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Правильні відповіді: $correctAnswers ${_getEmoji(correctAnswers)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Неправильні відповіді: $wrongAnswers ${_getEmoji(wrongAnswers, isWrong: true)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Точність: $accuracy% ${_getAccuracyEmoji(accuracy)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _navigation.goToHome(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'На головну 🏠',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getEmoji(int count, {bool isWrong = false}) {
    if (isWrong) {
      return count == 0 ? '🌟' : count <= 2 ? '😊' : '🤔';
    }
    return count >= 8 ? '🌟' : count >= 6 ? '😊' : '👍';
  }

  String _getAccuracyEmoji(int accuracy) {
    if (accuracy >= 90) return '🏆';
    if (accuracy >= 70) return '🌟';
    if (accuracy >= 50) return '👍';
    return '💪';
  }
} 