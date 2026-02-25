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
  String status = "Sistema Pronto";
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    try {
      await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt");
      controller = CameraController(widget.cameras[0], ResolutionPreset.low, enableAudio: false);
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => status = "Errore Init");
    }
  }

  Future<void> analizza() async {
    if (controller == null || isBusy) return;
    setState(() { isBusy = true; status = "Analisi..."; });
    try {
      final img = await controller!.takePicture();
      var res = await Tflite.runModelOnImage(path: img.path, numResults: 1);
      setState(() {
        status = (res != null && res.isNotEmpty) ? "Vedo: ${res[0]['label']}" : "Non riconosco";
      });
    } catch (e) {
      setState(() => status = "Errore Analisi");
    } finally {
      isBusy = false;
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
              padding: const EdgeInsets.all(20),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(status, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: isBusy ? null : analizza, child: const Text("COSA VEDI?")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
