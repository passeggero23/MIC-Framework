import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
// Se model_loader.dart ti dà X rossa, assicurati che il file esista in lib/
import 'model_loader.dart';

class AIEngine {
  static final AIEngine _instance = AIEngine._internal();
  factory AIEngine() => _instance;
  AIEngine._internal();

  Interpreter? _imageInterpreter;
  Interpreter? _audioInterpreter;
  bool isModelLoaded = false;

  Future<void> initialize() async {
    try {
      // Configurazione ottimizzata per Android
      final options = InterpreterOptions()..threads = 4;
      
      // Caricamento modelli tramite ModelLoader
      final imageModel = await ModelLoader.loadModel('model_image.tflite');
      final audioModel = await ModelLoader.loadModel('model_audio.tflite');
      
      if (imageModel != null) {
        _imageInterpreter = Interpreter.fromFile(imageModel, options: options);
      }
      if (audioModel != null) {
        _audioInterpreter = Interpreter.fromFile(audioModel, options: options);
      }
      
      isModelLoaded = _imageInterpreter != null && _audioInterpreter != null;
      debugPrint('[AIEngine] Modelli pronti: $isModelLoaded');
    } catch (e) {
      debugPrint('[AIEngine] Errore inizializzazione: $e');
      isModelLoaded = false;
    }
  }

  // Analisi Immagine (Tensor 4D)
  List<double> analyzeFrame(List<dynamic> input) {
    if (!isModelLoaded || _imageInterpreter == null) return [];
    // Output standard per molti modelli MobileNet/Inception
    var output = List<double>.filled(1000, 0).reshape([1, 1000]);
    _imageInterpreter!.run(input, output);
    return List<double>.from(output[0]);
  }

  void dispose() {
    _imageInterpreter?.close();
    _audioInterpreter?.close();
    isModelLoaded = false;
  }
}
