import 'package:flutter/material.dart';
import 'package:flutter_starter/src/screens/bluetooth/bluetooth.dart';
import 'package:flutter_starter/src/screens/camera/camera_view.dart';
import 'package:flutter_starter/src/screens/home.dart';
import 'package:flutter_starter/src/screens/splash.dart';

class AppRoutes {
  static Widget splashScreen() {
    return const SplashScreen();
  }

  static Widget homeScreen() {
    return const HomeScreen();
  }

  static Widget bluetoothScreen() {
    return const BluetoothScreen();
  }

  static Widget cameraScreen() {
    return const CameraScreen();
  }
}
