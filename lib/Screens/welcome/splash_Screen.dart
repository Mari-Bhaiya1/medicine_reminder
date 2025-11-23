import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicinereminder/Screens/home/home.dart';
import 'package:medicinereminder/Screens/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.id);
    } else {
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 200.0,
                child: Image.asset('assets/images/welcome_image.png'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Medicine Reminder',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.black,
                    fontSize: 32.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
