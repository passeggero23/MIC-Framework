import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
      setState(() => statusMessage = "Preparazione file IA...");
      
      // Metodo Avanzato: Copiamo l'asset in un file reale per evitare errori di buffer
      final byteData = await rootBundle.load('assets/model.tflite');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/temp_model.tflite');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      setState(() => statusMessage = "Caricamento Interprete...");
      _interpreter = Interpreter.fromFile(file);
      
      setState(() => statusMessage = "Caricamento Label...");
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n');

      setState(() => statusMessage = "Avvio Camera...");
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      setState(() => statusMessage = "Pronto!");
    } catch (e) {
      setState(() => statusMessage = "ERRORE TECNICO:\n${e.toString()}");
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(statusMessage, textAlign: TextAlign.center),
              ),
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
            bottom: 50, left: 20, right: 20,
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
