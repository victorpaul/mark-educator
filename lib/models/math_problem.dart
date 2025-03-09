import 'dart:math';
import '../config/difficulty_config.dart';
import '../services/audio_service.dart';

/// Клас, що представляє математичну задачу додавання
class MathProblem {
  final int firstNumber;
  final int secondNumber;
  final String operation;
  final List<int> options;

  int get correctAnswer => operation == '+' 
    ? firstNumber + secondNumber 
    : firstNumber - secondNumber;

  const MathProblem({
    required this.firstNumber,
    required this.secondNumber,
    required this.operation,
    required this.options,
  });

  /// Створює нову випадкову задачу з додавання
  factory MathProblem.random(DifficultyLevel level, {
    MathProblem? previousProblem,
    String operation = '+',
  }) {
    int first;
    int second;
    int maxAttempts = 10;

    do {
      if (operation == '+') {
        // Для додавання
        first = Random().nextInt(level.maxNumber) + 1;
        second = Random().nextInt(level.maxNumber) + 1;
        // Перевіряємо, щоб сума не перевищувала максимальне значення
        if (first + second > level.maxSum) {
          continue;
        }
      } else {
        // Для віднімання
        first = Random().nextInt(level.maxNumber) + 1;
        second = Random().nextInt(first) + 1; // Друге число має бути менше першого
      }

      // Перевіряємо, чи нова задача відрізняється від попередньої
      if (previousProblem == null || 
          first != previousProblem.firstNumber || 
          second != previousProblem.secondNumber ||
          operation != previousProblem.operation) {
        break;
      }

      maxAttempts--;
    } while (maxAttempts > 0);

    final correctAnswer = operation == '+' ? first + second : first - second;
    final options = _generateOptions(correctAnswer, level.maxSum);

    return MathProblem(
      firstNumber: first,
      secondNumber: second,
      operation: operation,
      options: options,
    );
  }

  static List<int> _generateOptions(int correctAnswer, int maxSum) {
    final options = <int>{correctAnswer};
    final random = Random();

    // Генеруємо варіанти відповідей
    while (options.length < 4 && options.length < maxSum) {
      // Для малих чисел додаємо ближчі варіанти
      final diff = random.nextInt(3) + 1;
      final addOrSubtract = random.nextBool();
      
      final newOption = addOrSubtract 
        ? correctAnswer + diff 
        : correctAnswer - diff;

      if (newOption > 0 && newOption <= maxSum) {
        options.add(newOption);
      }
    }

    return options.toList()..shuffle();
  }

  /// Отримати кількість варіантів відповідей
  int get optionsCount => options.length;

  /// Перевірити чи є відповідь правильною
  bool isCorrectAnswer(int answer) => answer == correctAnswer;

  /// Перевірити чи задача така ж як інша
  bool isSameAs(MathProblem other) {
    return firstNumber == other.firstNumber &&
           secondNumber == other.secondNumber &&
           operation == other.operation;
  }
}