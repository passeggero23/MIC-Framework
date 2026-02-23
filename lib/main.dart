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
  String label = "Inquadra qualcosa...";
  double confidence = 0.0;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  initCamera() {
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) return;
      controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          runModelOnFrame(image);
        }
      });
      setState(() {});
    });
  }

  runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      numResults: 1,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        label = recognitions[0]['label'];
        confidence = recognitions[0]['confidence'] * 100;
      });
    }
    isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(20),
              child: Text(
                "$label (${confidence.toStringAsFixed(0)}%)",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
