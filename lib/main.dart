import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MicAgent(cameras: cameras),
  ));
}

class MicAgent extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MicAgent({super.key, required this.cameras});

  @override
  State<MicAgent> createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String status = "Pronto";
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      
      controller = CameraController(widget.cameras[0], ResolutionPreset.low);
      await controller!.initialize();
      if (mounted) setState(() => isReady = true);
    } catch (e) {
      setState(() => status = "Errore: $e");
    }
  }

  Future<void> analizza() async {
    if (controller == null || !controller!.value.isInitialized) return;
    setState(() => status = "Analisi...");
    try {
      final image = await controller!.takePicture();
      var predictions = await Tflite.runModelOnImage(path: image.path, numResults: 1);
      setState(() {
        status = (predictions != null && predictions.isNotEmpty) 
          ? "Vedo: ${predictions[0]['label']}" 
          : "Nulla di noto";
      });
    } catch (e) {
      setState(() => status = "Errore analisi");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) return Scaffold(body: Center(child: Text(status)));

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.black87,
                    child: Text(status, style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: analizza,
                    child: const Text("COSA VEDI?"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
