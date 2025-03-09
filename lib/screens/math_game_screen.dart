import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/math_problem.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';
import '../services/firework_service.dart';
import '../services/audio_service.dart';
import '../config/difficulty_config.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/number_visualizer.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({super.key});

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  late MathProblem _currentProblem;
  MathProblem? _previousProblem;
  final GlobalKey _shakeKey = GlobalKey();
  final _notify = NotificationService();
  final _firework = FireworkService();
  final _audio = AudioService();
  DifficultyLevel _selectedLevel = DifficultyConfig.levels.first;

  @override
  void initState() {
    super.initState();
    _currentProblem = MathProblem.random(_selectedLevel);
    _playProblemAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notify.initialize(context);
  }

  /// Відтворює звуки для поточної математичної задачі
  Future<void> _playProblemAudio() async {
    await _audio.playNumber(_currentProblem.firstNumber);
    await Future.delayed(const Duration(milliseconds: 500));
    await _audio.playMathOperation('+');
    await Future.delayed(const Duration(milliseconds: 500));
    await _audio.playNumber(_currentProblem.secondNumber);
    await Future.delayed(const Duration(milliseconds: 500));
    await _audio.playMathOperation('=');
  }

  void _generateNewProblem() {
    setState(() {
      _previousProblem = _currentProblem;
      _currentProblem = MathProblem.random(_selectedLevel, _previousProblem);
    });
    // Відтворюємо звуки після генерації нової задачі
    _playProblemAudio();
  }

  void _checkAnswer(int selectedAnswer) async {
    if (selectedAnswer == _currentProblem.correctAnswer) {
      await _audio.playCorrectAnswer();
      _notify.showSuccess('Правильно! Молодець! 🎉');
      _firework.show(context, onComplete: _generateNewProblem);
    } else {
      await _audio.playWrongAnswer();
      _notify.showError('Спробуй ще раз! 🤔');
      _shakeScreen();
    }
  }

  void _onDifficultyChanged(DifficultyLevel level) {
    setState(() {
      _selectedLevel = level;
      _previousProblem = null; // Скидаємо попередню задачу при зміні рівня
      _currentProblem = MathProblem.random(level);
    });
    _notify.showSuccess('Рівень змінено на: ${level.name} ${level.emoji}');
    // Відтворюємо звуки після зміни рівня складності
    _playProblemAudio();
  }

  void _shakeScreen() {
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: AppTheme.defaultAnimationDuration,
    );
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Селектор складності
            Align(
              alignment: Alignment.centerRight,
              child: DifficultySelector(
                selectedLevel: _selectedLevel,
                onLevelSelected: _onDifficultyChanged,
              ),
            ),
            // Основний контент
            Expanded(
              child: Row(
                children: [
                  // Ліва частина - задача
                  Expanded(
                    child: Container(
                      color: AppTheme.questionContainerColor,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Перше число
                              Expanded(
                                child: NumberVisualizer(
                                  number: _currentProblem.firstNumber,
                                  size: 32,
                                  isAnimated: true,
                                  backgroundColor: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              // Друге число
                              Expanded(
                                child: NumberVisualizer(
                                  number: _currentProblem.secondNumber,
                                  size: 32,
                                  isAnimated: true,
                                  backgroundColor: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '=',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              // Знак питання
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    '?',
                                    style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).animate(key: _shakeKey)
                            .shake(duration: AppTheme.defaultAnimationDuration),
                        ],
                      ),
                    ),
                  ),
                  // Права частина - варіанти відповідей
                  Expanded(
                    child: Container(
                      color: AppTheme.answersContainerColor,
                      padding: AppTheme.defaultPadding,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = _currentProblem.optionsCount <= 2 ? 1 : 2;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: _currentProblem.optionsCount <= 2 ? 2.5 : 1.0,
                            children: _currentProblem.options.map((option) {
                              return ElevatedButton(
                                onPressed: () => _checkAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: NumberVisualizer(
                                  number: option,
                                  size: 24,
                                  backgroundColor: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  numberStyle: AppTheme.answerButtonTextStyle,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 