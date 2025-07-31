import 'package:blast_caller_app/widgets/helper_methods.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../quick_launch_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      // Navigate to QuickLaunchScreen on successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const QuickLaunchScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage =
            'Login failed. Please check your credentials and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051630), // Deep dark blue/gray
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/qag-logo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 10),

                // Title
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 32),

                // Login form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email / Username field
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration("Username", Icons.person),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            inputDecoration("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      // const SizedBox(height: 12),

                      // // Forgot password
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: const Text(
                      //       'Forgot password?',
                      //       style: TextStyle(
                      //         color: Colors.tealAccent,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 16),

                      // Error message
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 16),

                      // Sign in button
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isLoading ? 0.7 : 1,
                        child: GestureDetector(
                          onTap: _isLoading ? null : _login,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Or divider
                      // const Row(
                      //   children: [
                      //     Expanded(child: Divider(color: Colors.white24)),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                      //       child: Text("Or Sign In with",
                      //           style: TextStyle(color: Colors.white70)),
                      //     ),
                      //     Expanded(child: Divider(color: Colors.white24)),
                      //   ],
                      // ),

                      // const SizedBox(height: 16),

                      // // Social buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     socialButton(
                      //         icon: Icons.facebook,
                      //         label: 'Facebook',
                      //         color: Colors.blue),
                      //     socialButton(
                      //         icon: Icons.g_mobiledata,
                      //         label: 'Google',
                      //         color: Colors.red),
                      //   ],
                      // ),

                      const SizedBox(height: 24),

                      // Sign up
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text("Don't have an account? ",
                      //         style: TextStyle(color: Colors.white60)),
                      //     GestureDetector(
                      //       onTap: () {
                      //         // Handle signup
                      //       },
                      //       child: const Text(
                      //         'Sign Up',
                      //         style: TextStyle(
                      //           color: Colors.tealAccent,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
