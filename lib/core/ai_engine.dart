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
      // Estrazione asset
      File modelFile = await ModelLoader.loadModel(currentModel);
      
      // Inizializzazione Interprete TFLite
      _interpreter = Interpreter.fromFile(modelFile);
      
      isModelLoaded = _interpreter != null;
      return isModelLoaded;
    } catch (e) {
      // Log dell'errore per debugging in console
      print("MIC ENGINE ERROR: $e");
      isModelLoaded = false;
      return false;
    }
  }

  void dispose() {
    _interpreter?.close();
    isModelLoaded = false;
  }
}
