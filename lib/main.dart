import 'package:flutter/material.dart';
import 'package:merchantfe/screens/splash_screen_1.dart';
import 'package:merchantfe/screens/login_screen_masuk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen1(), // Mulai dari Splash Screen 1
    );
  }
}
