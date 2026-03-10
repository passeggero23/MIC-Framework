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
  runApp(const MaterialApp(
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
      setState(() => statusMessage = "Configurazione IA...");
      final byteData = await rootBundle.load('assets/model.tflite');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/model.tflite');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Caricamento con supporto Select-Ops (Flex)
      _interpreter = Interpreter.fromFile(file);
      
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();

      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      setState(() => statusMessage = "Pronto!");
    } catch (e) {
      setState(() => statusMessage = "ERRORE:\n$e");
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
      return Scaffold(body: Center(child: Text(statusMessage, textAlign: TextAlign.center)));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              color: Colors.black54,
              child: Text(
                "SISTEMA ATTIVO\nClassi: ${_labels?.length ?? 0}",
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
