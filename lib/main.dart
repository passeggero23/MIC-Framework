import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: MicAgent(cameras: cameras)));
}

class MicAgent extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MicAgent({super.key, required this.cameras});
  @override
  State<MicAgent> createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String label = "Inquadra e premi";
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      controller = CameraController(widget.cameras[0], ResolutionPreset.low);
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => label = "Errore setup: $e");
    }
  }

  void analizza() async {
    if (controller == null || isBusy) return;
    setState(() => label = "Analisi...");

    try {
      final image = await controller!.takePicture();
      
      var predictions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        if (predictions != null && predictions.isNotEmpty) {
          label = predictions[0]['label'];
        } else {
          label = "Oggetto non riconosciuto";
        }
      });
    } catch (e) {
      setState(() => label = "Errore tecnico");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              padding: const EdgeInsets.all(15),
              color: Colors.black87,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 15),
                  ElevatedButton(onPressed: analizza, child: const Text("ANALIZZA ORA")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
