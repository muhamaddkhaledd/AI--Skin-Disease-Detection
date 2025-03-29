import 'package:ai_powered_skin_disease_detection_application/screens/model%20screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  late CameraDescription _camera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _camera = cameras.first; // Use the first available camera

      _controller = CameraController(
        _camera,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      if (!_isCameraInitialized) return;

      final image = await _controller.takePicture();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModelScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error capturing photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing photo: $e')),
      );
    }
  }

  Future<void> _switchCamera() async {
    try {
      final cameras = await availableCameras();
      final newCamera = cameras.firstWhere(
            (camera) => camera.lensDirection != _camera.lensDirection,
        orElse: () => _camera, // fallback to current camera if no other found
      );

      if (newCamera.lensDirection == _camera.lensDirection) return;

      await _controller.dispose();
      setState(() {
        _camera = newCamera;
        _controller = CameraController(
          _camera,
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _controller.initialize();
        _isCameraInitialized = false;
      });
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: _capturePhoto,
        backgroundColor: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.circle, size: 55, color: Colors.black),
            Icon(Icons.circle, size: 44, color: Colors.white),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error initializing camera'));
                }
                return Container(
                  width: double.infinity,
                  child: CameraPreview(_controller),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 40),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.flash_on),
                  Text('Identify the disease'),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                shape: CircleBorder(),
                color: Color.fromRGBO(169, 169, 169, 0.2),
                onPressed: _switchCamera,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.flip_camera_android),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

