import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: MicAgent(cameras: cameras)));
}

class MicAgent extends StatefulWidget {
  final List<CameraDescription> cameras;
  MicAgent({required this.cameras});

  @override
  _MicAgentState createState() => _MicAgentState();
}

class _MicAgentState extends State<MicAgent> {
  CameraController? controller;
  String label = "Inizializzazione...";
  bool isBusy = false;

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
      
      controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      
      controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          runModel(image);
        }
      });
      setState(() {});
    } catch (e) {
      setState(() => label = "Errore: $e");
    }
  }

  runModel(CameraImage image) async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((p) => p.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      numResults: 1,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        label = recognitions[0]['label'];
      });
    }
    isBusy = false;
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
      return Scaffold(body: Center(child: Text(label)));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(label, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
