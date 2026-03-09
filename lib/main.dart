import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Richiesta rigorosa permessi
  var status = await Permission.camera.request();
  if (status.isGranted) {
    _cameras = await availableCameras();
    runApp(const MicApp());
  } else {
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Text("Permesso Camera Negato")))));
  }
}

class MicApp extends StatefulWidget {
  const MicApp({super.key});
  @override
  State<MicApp> createState() => _MicAppState();
}

class _MicAppState extends State<MicApp> {
  CameraController? controller;
  Interpreter? _interpreter;
  List<String>? _labels;

  @override
  void initState() {
    super.initState();
    _setupApp();
  }

  Future<void> _setupApp() async {
    // Caricamento Asset IA
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    final labelData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
    _labels = labelData.split('\n');

    // Inizializzazione Camera
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Container();
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            CameraPreview(controller!),
            Positioned(
              bottom: 30,
              left: 20,
              child: Text(
                "IA Pronta: ${_labels?.length ?? 0} classi caricate",
                style: const TextStyle(color: Colors.white, backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
