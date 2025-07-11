import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:senior_project/main.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // back camera
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      print('No cameras available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-time Camera")),
      body: _isCameraInitialized
          ? CameraPreview(_cameraController)
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }
}
