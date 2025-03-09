import 'dart:math';
import 'package:flutter/material.dart';

class FireworkParticle {
  late double x;
  late double y;
  late Color color;
  late double velocity;
  late double angle;
  late double size;
  late double alpha;

  FireworkParticle(double startX, double startY) {
    x = startX;
    y = startY;
    Random random = Random();
    
    // Випадковий колір для частинки
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    color = colors[random.nextInt(colors.length)];
    
    // Випадкова швидкість та кут руху
    velocity = random.nextDouble() * 12 + 6; // Збільшена швидкість
    angle = random.nextDouble() * 2 * pi;
    size = random.nextDouble() * 6 + 4; // Збільшений розмір частинок
    alpha = 1.0;
  }

  void update() {
    x += cos(angle) * velocity;
    y += sin(angle) * velocity - 1.5; // Збільшена гравітація
    velocity *= 0.95;
    alpha *= 0.97; // Повільніше затухання
  }
}

class FireworkAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const FireworkAnimation({
    super.key,
    required this.onComplete,
  });

  @override
  State<FireworkAnimation> createState() => _FireworkAnimationState();
}

class _FireworkAnimationState extends State<FireworkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<List<FireworkParticle>> fireworks = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Створюємо 5 феєрверків замість 3
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 250), () {
        if (mounted) {
          _addFirework();
        }
      });
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  void _addFirework() {
    setState(() {
      double startX = random.nextDouble() * MediaQuery.of(context).size.width;
      double startY = random.nextDouble() * MediaQuery.of(context).size.height * 0.5;
      List<FireworkParticle> particles = List.generate(
        80, // Збільшена кількість частинок
        (_) => FireworkParticle(startX, startY),
      );
      fireworks.add(particles);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: FireworkPainter(fireworks),
        );
      },
    );
  }
}

class FireworkPainter extends CustomPainter {
  final List<List<FireworkParticle>> fireworks;

  FireworkPainter(this.fireworks);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particles in fireworks) {
      for (var particle in particles) {
        final paint = Paint()
          ..color = particle.color.withOpacity(particle.alpha)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = particle.size
          ..blendMode = BlendMode.srcOver; // Додаємо режим змішування для кращого ефекту

        // Малюємо світіння навколо частинки
        final glowPaint = Paint()
          ..color = particle.color.withOpacity(particle.alpha * 0.3)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = particle.size * 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          glowPaint,
        );

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size / 2,
          paint,
        );

        particle.update();
      }
    }
  }

  @override
  bool shouldRepaint(FireworkPainter oldDelegate) => true;
} 