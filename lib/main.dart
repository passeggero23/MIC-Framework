import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: MicAgent(cameras: cameras), debugShowCheckedModeBanner: false));
}

class MicAgent extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MicAgent({super.key, required this.cameras});
  @override
  State<MicAgent> createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String label = "Sistema Pronto";
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt");
    controller = CameraController(widget.cameras[0], ResolutionPreset.low, enableAudio: false);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> analizza() async {
    if (controller == null || isBusy) return;
    setState(() { isBusy = true; label = "Analisi..."; });

    try {
      final img = await controller!.takePicture();
      
      // Analisi con parametri di memoria ridotti
      var result = await Tflite.runModelOnImage(
        path: img.path,
        numResults: 1,
        threshold: 0.1,
        asynch: true // Esegue in background per non bloccare l'app
      );

      setState(() {
        label = (result != null && result.isNotEmpty) ? result[0]['label'] : "Oggetto non chiaro";
      });
    } catch (e) {
      setState(() => label = "Riprova");
    } finally {
      isBusy = false;
    }
  }

  @override
  void dispose() {
    Tflite.close();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: isBusy ? null : analizza, child: const Text("ANALIZZA")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
