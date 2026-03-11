import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CameraController? _controller;
  Interpreter? _interpreter;
  String _status = "Inizializzazione...";

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    try {
      // Caricamento modello IA
      final data = await rootBundle.load('assets/model.tflite');
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/model.tflite');
      await file.writeAsBytes(data.buffer.asUint8List());
      
      _interpreter = Interpreter.fromFile(file);
      
      // Inizializzazione Camera
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("Nessuna camera trovata");
      
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      
      if (mounted) setState(() => _status = "IA PRONTA");
    } catch (e) {
      if (mounted) setState(() => _status = "Errore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(body: Center(child: Text(_status)));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            top: 40, left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(_status, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}
