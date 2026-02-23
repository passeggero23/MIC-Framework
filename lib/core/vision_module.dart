import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MICScanner extends StatefulWidget {
  const MICScanner({super.key});

  @override
  State<MICScanner> createState() => _MICScannerState();
}

class _MICScannerState extends State<MICScanner> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0], 
        ResolutionPreset.medium, // Bilanciamento perfetto tra velocità e dettaglio
        enableAudio: false,
      );

      _controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        // Qui l'occhio inizia a inviare frame al motore
        _controller?.startImageStream((CameraImage image) {
          // Socio, qui è dove il C++ inizierà a macinare i dati
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }
    return CameraPreview(_controller!);
  }
}
