import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal();

  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
  }

  void showSuccess(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).clearSnackBars();

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              message,
              style: AppTheme.snackBarTextStyle,
            ),
          ],
        ),
        backgroundColor: AppTheme.successSnackBarColor,
        duration: AppTheme.snackBarDuration,
        margin: AppTheme.snackBarMargin,
        padding: AppTheme.snackBarPadding,
        elevation: AppTheme.snackBarElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.snackBarBorderRadius,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showError(String message) {
    if (_context == null) return;


    ScaffoldMessenger.of(_context!).clearSnackBars();

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              message,
              style: AppTheme.snackBarTextStyle,
            ),
          ],
        ),
        backgroundColor: AppTheme.errorSnackBarColor,
        duration: AppTheme.snackBarDuration,
        margin: AppTheme.snackBarMargin,
        padding: AppTheme.snackBarPadding,
        elevation: AppTheme.snackBarElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.snackBarBorderRadius,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 