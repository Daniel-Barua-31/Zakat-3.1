// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/routes.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCalculatePressed() async {
    setState(() => _isCalculating = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isCalculating = false);
    Navigator.pushNamed(context, MyRoutes.SelectedRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Stack(
        children: [
          // Abstract background pattern
          CustomPaint(
            painter: AbstractBackgroundPainter(_controller),
            size: Size.infinite,
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Abstract Zakat symbol
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: ZakatSymbolPainter(_controller),
                          ),
                        ),
                        SizedBox(height: 50),
                        // Zakat text letter by letter
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Text(
                              _getAnimatedText(),
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 36,
                                letterSpacing: 8,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Purify • Grow • Share",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: _isCalculating ? null : _onCalculatePressed,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: _isCalculating ? 60 : 200,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isCalculating
                                ? CircularProgressIndicator(
                                    color: Colors.green.shade400)
                                : Text(
                                    "Calculate",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade400,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Add space between button and text
                      Text(
                        "Powered By",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Since 2000",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFF7F8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get the animated text
  String _getAnimatedText() {
    const word = "ZAKAT";
    int letterCount = (word.length * _controller.value).floor();
    return word.substring(0, math.min(letterCount, word.length));
  }
}

class AbstractBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  AbstractBackgroundPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 5; i++) {
      final progress = (animation.value + i / 5) % 1.0;
      final center = Offset(size.width / 2, size.height / 2);
      final radius = size.width * (0.2 + progress * 0.8);

      Path path = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius))
        ..addOval(Rect.fromCircle(center: center, radius: radius * 0.8));

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ZakatSymbolPainter extends CustomPainter {
  final Animation<double> animation;

  ZakatSymbolPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width * 0.6; // Adjust width for the "Z"
    final height = size.height * 0.6; // Adjust height for the "Z"
    const gap = 20.0; // Distance between the "Z" and the circle

    // Draw the "Z" path
    final zPath = Path()
      ..moveTo(center.dx - width / 2, center.dy - height / 2) // Top left
      ..lineTo(center.dx + width / 2, center.dy - height / 2) // Top right
      ..lineTo(center.dx - width / 2, center.dy + height / 2) // Bottom left
      ..lineTo(center.dx + width / 2, center.dy + height / 2); // Bottom right

    // Compute the progress of the Z path animation
    final progress = math.min(
        animation.value * 2, 1.0); // Z path animation progresses until halfway

    PathMetric zMetric = zPath.computeMetrics().first;
    Path animatedZ = zMetric.extractPath(0, zMetric.length * progress);

    // Always draw the Z completely when the animation finishes
    if (progress == 1.0) {
      canvas.drawPath(zPath, paint); // Draw full Z when animation completes
    } else {
      canvas.drawPath(animatedZ, paint); // Draw animated Z path
    }

    // If the animation has passed the halfway point, start drawing the circle in a counterclockwise direction
    if (animation.value > 0.5) {
      final circleProgress = (animation.value - 0.5) *
          2; // Circle starts at 50% of animation duration
      final radius = math.min(size.width, size.height) * 0.5 +
          gap; // Circle radius with gap
      final circlePath = Path()
        ..addArc(
            Rect.fromCircle(center: center, radius: radius),
            math.pi / 6, // Starting angle
            -math.pi *
                2 *
                circleProgress); // Negative sweep for counterclockwise

      // Always draw the full circle when the animation completes
      if (circleProgress == 1.0) {
        canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            math.pi / 6,
            -math.pi * 2,
            false,
            paint); // Draw full circle in counterclockwise
      } else {
        canvas.drawPath(circlePath,
            paint); // Draw animated circle path in counterclockwise direction
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
