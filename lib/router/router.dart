import 'package:flutter/material.dart';
import 'package:flutter_starter/screens/home.dart';
import 'package:flutter_starter/screens/splash.dart';

class AppRoutes {
  static Widget splashScreen() {
    return const SplashScreen();
  }

  static Widget homeScreen() {
    return const HomeScreen();
  }
}
