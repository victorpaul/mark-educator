import 'dart:math';
import '../config/difficulty_config.dart';
import '../services/audio_service.dart';

/// Клас, що представляє математичну задачу додавання
class MathProblem {
  final int firstNumber;
  final int secondNumber;
  final int correctAnswer;
  final List<int> options;

  MathProblem({
    required this.firstNumber,
    required this.secondNumber,
    required this.correctAnswer,
    required this.options,
  });

  /// Створює нову випадкову задачу з додавання
  factory MathProblem.random(DifficultyLevel level, [MathProblem? previousProblem]) {
    final random = Random();
    int first;
    int second;
    int sum;

    // Генеруємо числа поки не отримаємо відповідні умовам
    do {
      // Генеруємо випадкові числа в межах рівня складності
      first = level.minNumber + random.nextInt(level.maxNumber - level.minNumber + 1);
      second = level.minNumber + random.nextInt(level.maxNumber - level.minNumber + 1);
      sum = first + second;

      // Перевіряємо чи це не та сама задача що була раніше
      final isSameAsPrevious = previousProblem != null &&
          ((first == previousProblem.firstNumber && second == previousProblem.secondNumber) ||
           (first == previousProblem.secondNumber && second == previousProblem.firstNumber));

      // Продовжуємо генерувати, якщо сума завелика або задача така ж як попередня
      if (sum <= level.maxSum && !isSameAsPrevious) {
        break;
      }
    } while (true);

    // Створюємо масив можливих відповідей від 1 до максимальної суми
    final possibleAnswers = List<int>.generate(level.maxSum, (i) => i + 1);
    possibleAnswers.remove(sum); // Видаляємо правильну відповідь
    possibleAnswers.shuffle(); // Перемішуємо

    // Беремо до трьох неправильних відповідей
    final wrongAnswers = possibleAnswers.take(3).toList();
    
    // Додаємо правильну відповідь і перемішуємо
    final options = [...wrongAnswers, sum]..shuffle();

    return MathProblem(
      firstNumber: first,
      secondNumber: second,
      correctAnswer: sum,
      options: options,
    );
  }

  /// Отримати кількість варіантів відповідей
  int get optionsCount => options.length;

  /// Перевірити чи є відповідь правильною
  bool isCorrectAnswer(int answer) => answer == correctAnswer;

  /// Перевірити чи задача така ж як інша
  bool isSameAs(MathProblem other) {
    return (firstNumber == other.firstNumber && secondNumber == other.secondNumber) ||
           (firstNumber == other.secondNumber && secondNumber == other.firstNumber);
  }
}