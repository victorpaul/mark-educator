import 'package:flutter/material.dart';

class NumberVisualizer extends StatelessWidget {
  final int number;
  final double size;
  final bool isAnimated;
  final TextStyle? numberStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const NumberVisualizer({
    super.key,
    required this.number,
    this.size = 24,
    this.isAnimated = false,
    this.numberStyle,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Число
          Text(
            number.toString(),
            style: numberStyle ?? TextStyle(
              fontSize: size * 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Котики
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(
                  number,
                  (index) => _buildCat(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCat(int index) {
    Widget cat = Text(
      '🐱',
      style: TextStyle(
        fontSize: size,
      ),
    );

    if (isAnimated) {
      cat = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 100 * (index + 1)),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: cat,
      );
    }

    return cat;
  }
} 