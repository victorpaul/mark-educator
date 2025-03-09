import 'package:flutter/material.dart';

class ProgressTrain extends StatefulWidget {
  final int correctAnswers;
  final int targetAnswers;
  final int answersPerCarriage;

  const ProgressTrain({
    super.key,
    required this.correctAnswers,
    required this.targetAnswers,
    this.answersPerCarriage = 2,
  });

  @override
  State<ProgressTrain> createState() => _ProgressTrainState();
}

class _ProgressTrainState extends State<ProgressTrain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(ProgressTrain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.correctAnswers != widget.correctAnswers) {
      _previousProgress = oldWidget.correctAnswers / oldWidget.targetAnswers;
      _updateAnimation();
      _controller.forward(from: 0);
    }
  }

  void _updateAnimation() {
    final progress = widget.correctAnswers / widget.targetAnswers;
    _animation = Tween<double>(
      begin: _previousProgress,
      end: progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(40),
      ),
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Потяг
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                right: _animation.value * (MediaQuery.of(context).size.width - 180) + 40,
                bottom: 10,
                child: Row(
                  children: [
                    // Локомотив
                    const Text('🚂', style: TextStyle(fontSize: 40)),
                    // Вагони (по одному за кожні N правильних відповідей)
                    ...List.generate(
                      (widget.correctAnswers / widget.answersPerCarriage).floor(),
                      (index) => const Text('🚃', style: TextStyle(fontSize: 40)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 