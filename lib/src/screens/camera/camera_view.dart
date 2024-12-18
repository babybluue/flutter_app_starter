import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> _cameras;
  late CameraController? _cameraControllerBack;
  late CameraController? _cameraControllerFront;

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    _cameras = await availableCameras();
    _cameraControllerBack = CameraController([], ResolutionPreset.max);
    _cameraControllerFront = CameraController([], ResolutionPreset.max);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: null, child: const Text('Open Camera')),
          TextButton(onPressed: null, child: const Text('Start Scanning')),
        ],
      ),
    );
  }
}
