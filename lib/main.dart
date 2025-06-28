import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  double carSpeed = 0.0; // سرعة السيارة
  String detectedSpeedLimit = '---'; // سرعة اللوحة

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startSpeedTracking();
  }

  Future<void> _initCamera() async {
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // back camera
        ResolutionPreset.veryHigh,
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

  // تتبع سرعة السيارة GPS
  void _startSpeedTracking() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      double speedInKmh = position.speed * 3.6; // m/s إلى km/h
      setState(() {
        carSpeed = speedInKmh;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-time Camera")),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      'Car Speed: ${carSpeed.toStringAsFixed(1)} km/h',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.redAccent,
                    child: Text(
                      'Detected Limit: $detectedSpeedLimit km/h',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            )
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
