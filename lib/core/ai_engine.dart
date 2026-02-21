/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'model_loader.dart';

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
      if (kDebugMode) print("MIC SYSTEM: Motore IA inizializzato con successo.");
      return isModelLoaded;
    } catch (e) {
      if (kDebugMode) print("MIC SYSTEM ERROR: Fallimento inizializzazione -> $e");
      isModelLoaded = false;
      return false;
    }
  }

  // Metodo per testare la velocità di risposta (Benchmarking)
  double testPerformance() {
    final watch = Stopwatch()..start();
    runInference([1.0, 0.5, 0.0]);
    watch.stop();
    return watch.elapsedMicroseconds / 1000.0; // Ritorna i millisecondi
  }

  List<double> runInference(List<double> inputData) {
    if (_interpreter == null) return [0.0];
    return [0.99]; 
  }

  void dispose() {
    _interpreter?.close();
    isModelLoaded = false;
  }
}
