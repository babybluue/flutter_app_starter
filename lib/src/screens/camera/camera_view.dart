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
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    _cameras = await availableCameras();
    final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    print(_cameras);
    _cameraControllerBack = CameraController(backCamera, ResolutionPreset.high);
    _cameraControllerFront =
        CameraController(frontCamera, ResolutionPreset.max);

    await _cameraControllerBack?.initialize();
    await _cameraControllerFront?.initialize();
    setState(() {});
  }

  @override
  void dispose() async {
    _cameraControllerBack?.stopImageStream();
    _cameraControllerFront?.stopImageStream();
    _cameraControllerBack?.dispose();
    _cameraControllerFront?.dispose();
    super.dispose();
  }

  void startCamera() {
    // _cameraControllerBack?.startImageStream((image) {
    //   // TODO: process image
    // });
    // _cameraControllerFront?.startImageStream((image) {
    //   // TODO: process image
    // });
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
          TextButton(
              onPressed: () => startCamera(), child: const Text('Open Camera')),
          TextButton(onPressed: null, child: const Text('Start Scanning')),
          Expanded(
            child: Stack(
              children: [
                if (_cameraControllerBack!.value.isInitialized)
                  SizedBox(
                    width: 300,
                    height: 400,
                    child: CameraPreview(_cameraControllerBack!),
                  ),
                // if (_cameraControllerFront!.value.isInitialized)
                //   SizedBox(
                //     width: 300,
                //     height: 400,
                //     child: CameraPreview(_cameraControllerFront!),
                //   ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
