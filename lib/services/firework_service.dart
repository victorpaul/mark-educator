import 'package:flutter/material.dart';
import '../widgets/firework_animation.dart';

class FireworkService {
  static final FireworkService _instance = FireworkService._internal();
  
  factory FireworkService() {
    return _instance;
  }
  
  FireworkService._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context, {VoidCallback? onComplete}) {
    // Видаляємо попередній феєрверк, якщо він є
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: FireworkAnimation(
          onComplete: () {
            hide();
            onComplete?.call();
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
} 