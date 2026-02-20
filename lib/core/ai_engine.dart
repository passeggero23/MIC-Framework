/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'model_loader.dart';
import 'dart:io';

class AIEngine {
  bool isModelLoaded = false;
  String modelName = "mobilenet.tflite";

  static final AIEngine _instance = AIEngine._internal();
  factory AIEngine() => _instance;
  AIEngine._internal();

  /// Inizializza il modello AI estraendolo dagli assets
  Future<bool> initialize() async {
    try {
      File modelFile = await ModelLoader.loadModel(modelName);
      if (await modelFile.exists()) {
        isModelLoaded = true;
        return true;
      }
      return false;
    } catch (e) {
      isModelLoaded = false;
      return false;
    }
  }
}
