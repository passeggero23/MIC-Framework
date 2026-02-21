import 'package:camera/camera.dart';

class AIEngine {
  bool isModelLoaded = false; 

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    isModelLoaded = true;
  }

  String processCameraFrame(CameraImage image) {
    if (!isModelLoaded) return "In attesa...";
    return "Analisi attiva";
  }
}
