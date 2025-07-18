import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:senior_project/main.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (!mounted) return;

        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        print('❌ No cameras found.');
        setState(() => _hasError = true);
      }
    } catch (e) {
      print('❌ Camera error: $e');
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(child: Text("Failed to load camera"));
    }

    return _isCameraInitialized && _cameraController != null
        ? CameraPreview(_cameraController!)
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
