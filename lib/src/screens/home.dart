import 'package:flutter/material.dart';
import 'package:flutter_starter/src/router/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
            TextButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppRoutes.bluetoothScreen(),
                      ),
                    ),
                child: Text('Bluetooth')),
          ],
        ),
      ),
    );
  }
}
