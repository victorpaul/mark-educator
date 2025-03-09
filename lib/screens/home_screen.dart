import 'package:flutter/material.dart';
import '../config/difficulty_config.dart';
import '../services/navigation_service.dart';
import '../theme/app_theme.dart';
import './math_game_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/';
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[300]!,
                Colors.blue[100]!,
              ],
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Математичні Завдання',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildOperationSection('+', 'Додавання'),
                      const SizedBox(height: 32),
                      _buildOperationSection('-', 'Віднімання'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperationSection(String operation, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...DifficultyConfig.levels.map((level) => 
          _buildTaskCard(operation, level),
        ),
      ],
    );
  }

  Widget _buildTaskCard(String operation, DifficultyLevel level) {
    final navigation = NavigationService();
    final difficultyIndex = DifficultyConfig.levels.indexOf(level);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => navigation.goToWithParams(
          MathGameScreen.route,
          {
            'initialOperation': operation,
            'difficultyIndex': difficultyIndex,
          },
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    operation,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${level.name} ${level.emoji}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Числа до ${level.maxNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.blue,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 