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
  
  // Chiediamo i permessi prima di partire
  await Permission.camera.request();
  
  _cameras = await availableCameras();
  
  runApp(const MaterialApp(
    home: MicAIApp(),
    debugShowCheckedModeBanner: false, // Rimosso l'errore showErrorGrid
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
      setState(() => statusMessage = "Preparazione file modello...");
      
      // Carichiamo i byte del modello dagli asset
      final byteData = await rootBundle.load('assets/model.tflite');
      
      // Lo scriviamo in un file temporaneo (più stabile per i modelli grandi)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/model.tflite');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      setState(() => statusMessage = "Avvio motore IA...");
      // Inizializziamo l'interprete TensorFlow
      _interpreter = Interpreter.fromFile(file);
      
      setState(() => statusMessage = "Lettura etichette...");
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();

      setState(() =>
