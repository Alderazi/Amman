import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Getlocator extends StatefulWidget {
  @override
  _GetlocatorState createState() => _GetlocatorState();
}

class _GetlocatorState extends State<Getlocator> {
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndStartTracking();
  }

  Future<void> _checkPermissionAndStartTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    setState(() {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _positionStream == null
        ? Center(child: Text("Waiting for permission..."))
        : StreamBuilder<Position>(
            stream: _positionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double speed = snapshot.data!.speed;
                double speedKmh = speed * 3.6;
                return Center(
                  child: Text(
                    'Speed: ${speedKmh.toStringAsFixed(2)} km/h',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Location error"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
