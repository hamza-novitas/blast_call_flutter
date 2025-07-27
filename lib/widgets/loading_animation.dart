import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rocketYAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    // Rocket movement animation (goes up)
    _rocketYAnimation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Opacity animation for flames and smoke
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Scale animation for flames
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Launching Call',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base/launch pad
                  Positioned(
                    bottom: 10,
                    child: Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  // Flames and smoke
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 20 + (_rocketYAnimation.value.abs() * 50),
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.shade600,
                                    Colors.orange.shade300,
                                    Colors.yellow.shade200,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Rocket
                  AnimatedBuilder(
                    animation: _rocketYAnimation,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 20 + (_rocketYAnimation.value * 150),
                        child: Transform.translate(
                          offset: Offset(0, _rocketYAnimation.value * 150),
                          child: _buildRocket(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRocket() {
    return CustomPaint(
      size: const Size(40, 60),
      painter: RocketPainter(),
    );
  }
}

class RocketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bodyPaint = Paint()..color = const Color(0xFF1A237E);
    final Paint windowPaint = Paint()..color = Colors.lightBlueAccent;
    final Paint finPaint = Paint()..color = Colors.redAccent;

    // Body
    final Path bodyPath = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Window
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.4),
      size.width * 0.15,
      windowPaint,
    );

    // Left fin
    final Path leftFinPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.9)
      ..close();
    canvas.drawPath(leftFinPath, finPaint);

    // Right fin
    final Path rightFinPath = Path()
      ..moveTo(size.width * 0.8, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..close();
    canvas.drawPath(rightFinPath, finPaint);

    // Bottom fins
    final Path bottomFinPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.9)
      ..moveTo(size.width * 0.65, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.9);
    canvas.drawPath(bottomFinPath, finPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}