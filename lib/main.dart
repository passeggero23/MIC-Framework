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
    home: MicAIApp(), // Rimosso const
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

  @override
  void initState() {
    super.initState();
    _initializeEngine();
  }

  Future<void> _initializeEngine() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final labelData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelData.split('\n');
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Errore IA: $e");
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
    // Se la camera non è pronta, mostriamo un caricamento
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Rimosso const
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
            child: Container( // Rimosso const
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black54, 
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "IA MIC ATTIVA\nModello: ${_labels?.length ?? 0} classi",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
