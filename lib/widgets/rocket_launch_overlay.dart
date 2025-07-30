import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RocketLaunchOverlay extends StatefulWidget {
  final Color color;
  final VoidCallback onAnimationComplete;
  final Offset position;

  const RocketLaunchOverlay({
    Key? key,
    required this.color,
    required this.onAnimationComplete,
    required this.position,
  }) : super(key: key);

  @override
  State<RocketLaunchOverlay> createState() => _RocketLaunchOverlayState();
}

class _RocketLaunchOverlayState extends State<RocketLaunchOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _shakeAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _moveUpAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Shake horizontally for first 30% of animation
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -8, end: 0), weight: 30),
      TweenSequenceItem(tween: ConstantTween(0), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Rotate from 0 to 10 degrees over the animation
    _rotationAnimation =
        Tween<double>(begin: 0, end: 0.1745) // 10 degrees in radians
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Move rocket up by 250 pixels
    _moveUpAnimation = Tween<double>(begin: 0, end: -250).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Scale from 1 to 1.8
    _scaleAnimation = Tween<double>(begin: 1, end: 1.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Fade out from 1 to 0 near end (70%-100%)
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );

    // Glow pulses between 0.4 and 1 opacity repeatedly
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().whenComplete(() {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 75, // center horizontally assuming 150 width
      top: widget.position.dy - 75, // center vertically assuming 150 height
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(_shakeAnimation.value, _moveUpAnimation.value),
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow circle behind rocket
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color.withOpacity(_glowAnimation.value),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color
                                  .withOpacity(_glowAnimation.value * 0.6),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Lottie.asset(
                          'assets/animations/rocket_launch_improved.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller.duration = composition.duration *0.35;
                            _controller.forward(from: 0).whenComplete(() {
                              widget.onAnimationComplete();
                            });
                          },
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
