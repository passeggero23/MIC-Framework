/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */
import 'dart:io';
import 'package:flutter/services.dart';

class ModelLoader {
  static Future<File> loadModel(String modelName) async {
    final byteData = await rootBundle.load('assets/$modelName');
    final file = File('${Directory.systemTemp.path}/$modelName');
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes, byteData.lengthInBytes
    ));
    return file;
  }
}
