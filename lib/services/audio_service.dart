import 'dart:math';
import 'package:just_audio/just_audio.dart';

/// Сервіс для керування аудіо в грі
class AudioService {
  static final AudioService _instance = AudioService._internal();
  final _audioPlayer = AudioPlayer();
  final _random = Random();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  /// Відтворює випадковий звук правильної відповіді
  Future<void> playCorrectAnswer() async {
    final number = _random.nextInt(2) + 1;
    await _playAudio('assets/audio/correct_$number.wav');
  }

  /// Відтворює випадковий звук неправильної відповіді
  Future<void> playWrongAnswer() async {
    final number = _random.nextInt(2) + 1;
    await _playAudio('assets/audio/wrong_$number.wav');
  }

  /// Відтворює звук числа
  Future<void> playNumber(int number) async {
    await _playAudio('assets/audio/numbers/$number.wav');
  }

  /// Відтворює звук математичної операції
  Future<void> playMathOperation(String operation) async {
    final fileName = switch (operation) {
      '+' => 'plus',
      '-' => 'minus',
      '=' => 'eq',
      _ => throw ArgumentError('Непідтримувана операція: $operation'),
    };
    
    await _playAudio('assets/audio/math/$fileName.wav');
  }

  /// Допоміжний метод для відтворення аудіо файлу
  Future<void> _playAudio(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      print('Помилка відтворення аудіо $assetPath: $e');
    }
  }

  /// Звільняє ресурси
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
} 