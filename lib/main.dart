import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BlastCallerApp());
}

class BlastCallerApp extends StatelessWidget {
  const BlastCallerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blast Caller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF2196F3),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}