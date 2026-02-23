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
  String status = "Sistema Pronto";
  bool isBusy = false;
  bool isModelLoaded = false;

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
      isModelLoaded = true;
      
      controller = CameraController(
        widget.cameras[0], 
        ResolutionPreset.low,
        enableAudio: false,
      );
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => status = "Errore Iniziale");
    }
  }

  Future<void> analizza() async {
    if (controller == null || !controller!.value.isInitialized || isBusy || !isModelLoaded) return;

    setState(() {
      isBusy = true;
      status = "Analisi in corso...";
    });

    try {
      final image = await controller!.takePicture();
      
      var predictions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        threshold: 0.1,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        if (predictions != null && predictions.isNotEmpty) {
          status = "Vedo: ${predictions[0]['label']}";
        } else {
          status = "Nessun riscontro";
        }
      });
    } catch (e) {
      setState(() => status = "Riprova tra un attimo");
    } finally {
      isBusy = false;
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
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: CameraPreview(controller!)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status, 
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isBusy ? null : analizza,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      child: Text(
                        isBusy ? "ELABORAZIONE..." : "COSA VEDI?",
                        style: const TextStyle(fontSize: 18),
                      ),
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
