import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  _cameras = await availableCameras();
  runApp(MaterialApp(
    home: MicAIApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MicAIApp extends StatefulWidget {
  const MicAIApp({super.key});
  @override
  State<MicAIApp> createState() => _MicAIAppState();
}

class _MicAIAppState extends State<MicAIApp> {
  CameraController? controller;
  Interpreter? _interpreter;
  List<String>? _labels;
  String statusMessage = "Inizializzazione...";

  @override
  void initState() {
    super.initState();
    _initializeEngine();
  }

  Future<void> _initializeEngine() async {
    try {
      setState(() => statusMessage = "Caricamento Modello (6.55MB)...");
      // Lettura tramite Buffer per massima stabilità
      final modelData = await DefaultAssetBundle.of(context).load('assets/model.tflite');
      _interpreter = Interpreter.fromBuffer(modelData.buffer.asUint8List());
      
      setState(() => statusMessage = "Caricamento Label...");
      final labelData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelData.split('\n');

      setState(() => statusMessage = "Avvio Camera...");
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      setState(() => statusMessage = "Pronto!");
    } catch (e) {
      setState(() => statusMessage = "ERRORE FORMATO:\n${e.toString()}");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(statusMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
              child: Text(
                "IA MIC ATTIVA\nModello: ${_labels?.length ?? 0} classi",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
