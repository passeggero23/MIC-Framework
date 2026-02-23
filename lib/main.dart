import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MicAgent()));
}

class MicAgent extends StatefulWidget {
  const MicAgent({super.key});
  @override
  _MicAgentState createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String status = "Inizializzazione...";
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    try {
      // 1. Carica Modello
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );

      // 2. Setup Fotocamera
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("Nessuna camera trovata");

      controller = CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
      await controller!.initialize();
      
      setState(() {
        isReady = true;
        status = "Pronto";
      });
    } catch (e) {
      setState(() => status = "Errore Fatale: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(body: Center(child: Text(status, textAlign: TextAlign.center)));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              color: Colors.black87,
              child: Text(status, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
