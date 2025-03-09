import 'package:flutter/material.dart';
import '../config/difficulty_config.dart';
import '../theme/app_theme.dart';

class DifficultySelector extends StatelessWidget {
  final DifficultyLevel selectedLevel;
  final ValueChanged<DifficultyLevel> onLevelSelected;

  const DifficultySelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DifficultyConfig.levels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final level = DifficultyConfig.levels[index];
          final isSelected = level == selectedLevel;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onLevelSelected(level),
              borderRadius: BorderRadius.circular(25),
              child: AnimatedContainer(
                duration: AppTheme.defaultAnimationDuration,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? level.color.withOpacity(0.2) : Colors.transparent,
                  border: Border.all(
                    color: level.color,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      level.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      level.name,
                      style: TextStyle(
                        color: level.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 