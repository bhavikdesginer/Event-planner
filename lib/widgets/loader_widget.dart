import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Create an animation controller to handle the rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Circle (rotating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi, // Full rotation (2 * pi)
                child: child,
              );
            },
            child: CustomPaint(
              size: Size(35, 35), // Size of the outer circle
              painter: CirclePainter(3 / 4), // 3/4 circle for the outer circle
            ),
          ),
          // Inner Circle (rotating in reverse)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_controller.value * 2 * pi, // Reverse rotation
                child: child,
              );
            },
            child: CustomPaint(
              size: Size(20, 20), // Size of the inner circle
              painter: CirclePainter(3 / 4), // 3/4 circle for the inner circle
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double fraction; // Fraction for drawing the 3/4 circle

  CirclePainter(this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppTheme.colorPrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    double startAngle = -pi / 2; // Start from top center

    // Drawing a 3/4 circle
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      startAngle,
      1.5 * pi * fraction, // 3/4 of a circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
