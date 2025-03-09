import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Клас, що містить всі стилі та теми додатку
class AppTheme {
  // Кольори
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  // Кольори контейнерів
  static Color questionContainerColor = Colors.blue[100]!;
  static Color answersContainerColor = Colors.green[100]!;
  
  // Текстові стилі
  static TextStyle questionTextStyle = GoogleFonts.comicNeue(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: Colors.blue[900],
  );
  
  static TextStyle answerButtonTextStyle = GoogleFonts.comicNeue(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.green[900],
  );

  static TextStyle snackBarTextStyle = GoogleFonts.comicNeue(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  // Стилі кнопок
  static ButtonStyle answerButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(24),
  );
  
  // Стилі повідомлень
  static const Color successSnackBarColor = Color(0xFF4CAF50);
  static const Color errorSnackBarColor = Color(0xFFF44336);
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const double snackBarElevation = 8.0;
  static BorderRadius snackBarBorderRadius = BorderRadius.circular(16.0);
  static EdgeInsets snackBarMargin = const EdgeInsets.all(16.0);
  static EdgeInsets snackBarPadding = const EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );
  
  // Тема додатку
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      background: backgroundColor,
    ),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: answerButtonStyle,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: successSnackBarColor,
      elevation: snackBarElevation,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: snackBarBorderRadius,
      ),
    ),
  );
  
  // Відступи
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  
  // Анімації
  static const Duration defaultAnimationDuration = Duration(milliseconds: 500);
} 