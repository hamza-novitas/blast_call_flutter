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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Allow animation to run for a minimum time for better UX
    await Future.delayed(const Duration(milliseconds: 2500));
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Deep blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or app name
            const Text(
              'BLAST CALLER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            
            // Rocket animation
            SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset(
                'assets/animations/rocket_launch.json',
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Loading indicator
            if (!_isAnimationCompleted)
              const CircularProgressIndicator(
                color: Colors.white,
              )
            else
              const Text(
                'Launching...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}