import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MicAgent(cameras: cameras)));
}

class MicAgent extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MicAgent({super.key, required this.cameras});
  @override
  State<MicAgent> createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String status = "Inizializzazione...";
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    try {
      setState(() => status = "Caricamento Modello IA...");
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite", 
        labels: "assets/labels.txt"
      );
      
      setState(() => status = "Avvio Fotocamera...");
      controller = CameraController(widget.cameras[0], ResolutionPreset.low, enableAudio: false);
      await controller!.initialize();
      
      if (mounted) setState(() => status = "Sistema Pronto");
    } catch (e) {
      setState(() => status = "Errore: ${e.toString()}");
    }
  }

  Future<void> analizza() async {
    if (controller == null || !controller!.value.isInitialized || isBusy) return;
    setState(() { isBusy = true; status = "Analisi in corso..."; });
    try {
      final img = await controller!.takePicture();
      var res = await Tflite.runModelOnImage(path: img.path, numResults: 1);
      setState(() {
        status = (res != null && res.isNotEmpty) 
            ? "Vedo: ${res[0]['label']} (${(res[0]['confidence'] * 100).toStringAsFixed(0)}%)" 
            : "Oggetto non riconosciuto";
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
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              Text(status, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(status, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                      onPressed: isBusy ? null : analizza, 
                      child: const Text("COSA VEDI?"),
                    ),
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
