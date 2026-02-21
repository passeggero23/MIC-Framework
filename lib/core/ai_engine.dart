import 'package:camera/camera.dart';

class AIEngine {
  // Aggiungiamo questa variabile per la UI
  bool isModelLoaded = false; 

  // Rinominiamo il metodo per farlo combaciare con la chiamata della UI
  Future<void> initialize() async {
    // Simuliamo il caricamento
    await Future.delayed(Duration(seconds: 1));
    isModelLoaded = true;
    print("MIC-Engine: Sistema pronto.");
  }

  String processCameraFrame(CameraImage image) {
    if (!isModelLoaded) return "In attesa...";
    return "Analisi frame attiva";
  }
}
