import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MICScanner extends StatefulWidget {
  const MICScanner({super.key});

  @override
  State<MICScanner> createState() => _MICScannerState();
}

class _MICScannerState extends State<MICScanner> {
  CameraController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    
    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const Center(child: CircularProgressIndicator());
    return CameraPreview(_controller!); // Qui usiamo sia Camera che Material!
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
