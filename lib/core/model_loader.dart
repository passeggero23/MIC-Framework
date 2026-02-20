/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'dart:io';
import 'package:flutter/services.dart';

class ModelLoader {
  static Future<File> loadModel(String modelName) async {
    // Carica il file binario dagli assets del progetto
    final byteData = await rootBundle.load('assets/models/$modelName');
    
    // Crea un file fisico nella memoria temporanea del dispositivo
    final file = File('${Directory.systemTemp.path}/$modelName');
    
    // Scrive i byte nel file appena creato
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes, byteData.lengthInBytes
    ));
    
    return file;
  }
}
