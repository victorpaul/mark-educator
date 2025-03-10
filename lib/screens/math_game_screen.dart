import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mark/extensions/widgets_extensions.dart';
import '../models/math_problem.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';
import '../services/firework_service.dart';
import '../services/audio_service.dart';
import '../services/navigation_service.dart';
import '../config/difficulty_config.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/number_visualizer.dart';
import '../widgets/progress_train.dart';
import '../widgets/operation_selector.dart';
import './congratulation_screen.dart';

class MathGameScreen extends StatefulWidget {
  static const String route = '/math-game';
  
  final String? initialOperation;
  final int? difficultyIndex;

  const MathGameScreen({
    super.key,
    this.initialOperation,
    this.difficultyIndex,
  });

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  late MathProblem _currentProblem;
  MathProblem? _previousProblem;
  final _notify = NotificationService();
  final _firework = FireworkService();
  final _audio = AudioService();
  final _navigation = NavigationService();
  late DifficultyLevel _selectedLevel;
  late String _selectedOperation;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  final int _targetAnswers = 10;
  bool _optionsHidden = true;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();
    _selectedOperation = widget.initialOperation ?? '+';
    _selectedLevel = widget.difficultyIndex != null 
      ? DifficultyConfig.levels[widget.difficultyIndex!]
      : DifficultyConfig.levels.first;
    _currentProblem = MathProblem.random(_selectedLevel, operation: _selectedOperation);
    _blockAndPlayAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notify.initialize(context);
  }

  /// Відтворює звуки для поточної математичної задачі
  Future<void> _playProblemAudio() {
    return _audio
      .playNumber(_currentProblem.firstNumber)
      .then((_) => Future.delayed(const Duration(milliseconds: 500)))
      .then((_) => _audio.playMathOperation(_selectedOperation))
      .then((_) => Future.delayed(const Duration(milliseconds: 500)))
      .then((_) => _audio.playNumber(_currentProblem.secondNumber))
      .then((_) => Future.delayed(const Duration(milliseconds: 500)))
      .then((_) => _audio.playMathOperation('='));
  }

  void _blockAndPlayAudio() {
    setState(() => _optionsHidden = true);
    _playProblemAudio().then((_) {
      if (mounted) {
        setState(() => _optionsHidden = false);
      }
    });
  }

  void _generateNewProblem() {
    setState(() {
      _previousProblem = _currentProblem;
      _currentProblem = MathProblem.random(_selectedLevel, previousProblem: _previousProblem, operation: _selectedOperation);
    });
    _blockAndPlayAudio();
  }

  void _checkAnswer(int selectedAnswer) async {
    if (selectedAnswer == _currentProblem.correctAnswer) {
      setState(() {
        _correctAnswers++;
        _optionsHidden = true;
      });
      await _audio.playCorrectAnswer();

      if (_correctAnswers >= _targetAnswers) {
        _navigation.goToAndReplace(
          CongratulationScreen.route,
          args: {
            'correctAnswers': _correctAnswers,
            'totalAnswers': _correctAnswers + _wrongAnswers,
          },
        );
      } else {
        _firework.show(context, onComplete: () {
          setState(() => _optionsHidden = false);
          _generateNewProblem();
        });
      }
    } else {
      setState(() {
        _wrongAnswers++;
        _isShaking = true;
      });
      _audio.playWrongAnswer();
      _notify.showError('Спробуй ще раз! 🤔');
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isShaking = false);
      }
    }
  }

  void _onDifficultyChanged(DifficultyLevel level) {
    setState(() {
      _selectedLevel = level;
      _previousProblem = null;
      _currentProblem = MathProblem.random(level, operation: _selectedOperation);
      _correctAnswers = 0;
    });
    _notify.showSuccess('Рівень змінено на: ${level.name} ${level.emoji}');
    _blockAndPlayAudio();
  }

  void _onOperationChanged(String operation) {
    setState(() {
      _selectedOperation = operation;
      _previousProblem = null;
      _currentProblem = MathProblem.random(_selectedLevel, operation: operation);
      _correctAnswers = 0;
      _wrongAnswers = 0;
    });
    _notify.showSuccess('Операцію змінено на: ${operation == '+' ? 'додавання' : 'віднімання'}');
    _blockAndPlayAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Перемикачі
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Кнопка повернення на головну
                      IconButton(
                        onPressed: () => _navigation.goToHome(),
                        icon: const Icon(
                          Icons.home_rounded,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Перемикач операцій
                      OperationSelector(
                        selectedOperation: _selectedOperation,
                        onOperationSelected: _onOperationChanged,
                      ),
                      const SizedBox(width: 16),
                      // Селектор складності
                      DifficultySelector(
                        selectedLevel: _selectedLevel,
                        onLevelSelected: _onDifficultyChanged,
                      ).wrapExpanded(),
                    ],
                  ),
                ),
                // Прогрес-потяг
                ProgressTrain(
                  correctAnswers: _correctAnswers,
                  targetAnswers: _targetAnswers,
                  answersPerCarriage: 1,
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
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      _selectedOperation,
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
                              ).animate(target: _isShaking ? 1 : 0).shake(),
                            ],
                          ),
                        ),
                      ),
                      // Права частина - варіанти відповідей
                      Expanded(
                        child: Container(
                          color: AppTheme.answersContainerColor,
                          padding: AppTheme.defaultPadding,
                          child: _optionsHidden
                            ? const SizedBox.shrink()
                            : LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final itemWidth = width > 600 ? width / 2 - 24 : width - 32;
                                
                                return Center(
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: _currentProblem.options.map((option) {
                                      return SizedBox(
                                        width: itemWidth,
                                        child: AspectRatio(
                                          aspectRatio: 2,
                                          child: ElevatedButton(
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
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
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
          ],
        ),
      ),
    );
  }
} 