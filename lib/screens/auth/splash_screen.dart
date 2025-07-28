import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import '../../services/api_service.dart';
import '../quick_launch_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _backgroundColorAnimation;
  bool _isAnimationCompleted = false;
  bool _isAnimationLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xFF1E3A8A),
      end: const Color(0xFF0F1F4A),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Allow animation to run for a minimum time for better UX
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (!mounted) return;
    
    setState(() {
      _isAnimationCompleted = true;
    });
    
    // Check if user is already logged in
    final isLoggedIn = await ApiService.isLoggedIn();
    
    if (!mounted) return;
    
    // Navigate to appropriate screen
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const QuickLaunchScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF0F1F4A),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or app name with outer glow effect
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Text(
                        'BLAST CALLER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: Colors.blueAccent,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Rocket animation
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _isAnimationLoaded 
                        ? Lottie.asset(
                            'assets/animations/rocket_launch_improved.json',
                            controller: _animationController,
                            onLoaded: (composition) {
                              setState(() {
                                _isAnimationLoaded = true;
                              });
                              _animationController
                                ..duration = composition.duration
                                ..forward();
                            },
                          )
                        : Center(
                            child: Lottie.asset(
                              'assets/animations/rocket_launch.json',
                              onLoaded: (composition) {
                                setState(() {
                                  _isAnimationLoaded = true;
                                });
                                _animationController
                                  ..duration = composition.duration
                                  ..forward();
                              },
                            ),
                          ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Loading indicator with pulse animation
                    if (!_isAnimationCompleted)
                      _buildPulsingLoader()
                    else
                      const Text(
                        'Preparing for Launch...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  
  Widget _buildPulsingLoader() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3 + (value * 0.3)),
                Colors.blueAccent.withOpacity(0.5 + (value * 0.2)),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2 * value),
                blurRadius: 15 * value,
                spreadRadius: 5 * value,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LOADING',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 10),
              _buildDot(value, 0),
              _buildDot(value, 0.2),
              _buildDot(value, 0.4),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDot(double animValue, double delay) {
    final double opacity = ((animValue + delay) % 1);
    
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}