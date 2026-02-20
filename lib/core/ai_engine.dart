/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'dart:io';
import 'model_loader.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIEngine {
  bool isModelLoaded = false;
  String currentModel = "placeholder.tflite";
  Interpreter? _interpreter; 

  static final AIEngine _instance = AIEngine._internal();
  factory AIEngine() => _instance;
  AIEngine._internal();

  Future<bool> initialize() async {
    try {
      File modelFile = await ModelLoader.loadModel(currentModel);
      _interpreter = Interpreter.fromFile(modelFile);
      isModelLoaded = _interpreter != null;
      return isModelLoaded;
    } catch (e) {
      isModelLoaded = false;
      return false;
    }
  }

  /// Esegue l'analisi dei dati (Inference)
  /// Per ora simula il passaggio di un vettore di dati
  List<double> runInference(List<double> inputData) {
    if (_interpreter == null) return [0.0];

    // Prepariamo l'output (dipende dalla struttura del modello)
    var output = List<double>.filled(1, 0).reshape([1, 1]);
    
    // Esecuzione reale sul motore TFLite
    // Nota: Con il placeholder darà errore se il file non è un vero modello,
    // ma la logica di chiamata è ora cablata.
    // _interpreter!.run(inputData, output); 

    return [0.99]; // Simuliamo una confidenza del 99% per il test UI
  }

  void dispose() {
    _interpreter?.close();
  }
}
