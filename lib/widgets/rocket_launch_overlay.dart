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
  late Animation<double> _moveUpAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  double? _screenHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // We'll initialize animations in didChangeDependencies
    // where we can safely access MediaQuery
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;

    // Initialize animations now that we have screen height
    _moveUpAnimation = Tween<double>(
      begin: 0,
      end: -(_screenHeight! + 200), // Move up beyond screen height
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

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
      left: widget.position.dx - 75,
      top: widget.position.dy - 75,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _moveUpAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/rocket_launch_improved.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration * 0.125;
                      _controller.forward(from: 0).whenComplete(() {
                        widget.onAnimationComplete();
                      });
                    },
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
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
