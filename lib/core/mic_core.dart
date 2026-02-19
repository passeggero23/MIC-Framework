/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/services.dart';

class MicCore {
  static const MethodChannel _bridge = MethodChannel('com.mic.framework/core');
  
  String systemStatus = "Standby";
  bool isSecure = false;

  /// Inizializza il framework e verifica la connessione nativa
  Future<void> boot() async {
    try {
      final String result = await _bridge.invokeMethod('getCoreStatus');
      systemStatus = result; // Risponderà "MIC Core Active - Secure Mode"
      isSecure = true;
    } catch (e) {
      systemStatus = "Errore di boot: $e";
      isSecure = false;
    }
  }
}
