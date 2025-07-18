import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera/cameraPage.dart';
import 'location/getLocator.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } catch (e) {
    print('❌ Failed to get cameras: $e');
  }

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera & GPS Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera & Speed Tracker")),
      body: Column(
        children: [
          Expanded(flex: 2, child: CameraPage()),
          Expanded(flex: 1, child: Getlocator()),
        ],
      ),
    );
  }
}
