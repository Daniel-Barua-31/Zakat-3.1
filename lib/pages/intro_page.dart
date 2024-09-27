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
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
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
                        SizedBox(height: 20),
                        // Zakat text
                        Text(
                          "ZAKAT",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 36,
                            letterSpacing: 8,
                          ),
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
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw crescent
    final crescentPath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), math.pi / 6,
          math.pi * 3 / 2)
      ..arcTo(Rect.fromCircle(center: center, radius: radius * 0.7),
          math.pi * 5 / 3, -math.pi * 3 / 2, false);

    // Draw giving hand
    final handPath = Path()
      ..moveTo(center.dx - radius * 0.3, center.dy + radius * 0.5)
      ..quadraticBezierTo(center.dx, center.dy + radius * 0.7,
          center.dx + radius * 0.3, center.dy + radius * 0.5)
      ..quadraticBezierTo(center.dx + radius * 0.1, center.dy + radius * 0.3,
          center.dx - radius * 0.1, center.dy + radius * 0.4);

    final progress = animation.value;
    PathMetric crescentMetric = crescentPath.computeMetrics().first;
    Path animatedCrescent =
        crescentMetric.extractPath(0, crescentMetric.length * progress);

    PathMetric handMetric = handPath.computeMetrics().first;
    Path animatedHand = handMetric.extractPath(0, handMetric.length * progress);

    canvas.drawPath(animatedCrescent, paint);
    canvas.drawPath(animatedHand, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
