import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppNavigation(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 150, 
              height: 150,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.restaurant, 
                size: 100, 
                color: Colors.orange
              ),
            ),
            const SizedBox(height: 20),
            const Text("LAKResèt",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}