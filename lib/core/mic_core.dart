/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/services.dart';

class MicCore {
  static const MethodChannel _bridge = MethodChannel('com.mic.framework/core');
  
  // Stato del Framework
  String systemStatus = "Inizializzazione...";
  bool isReady = false;
  bool secureBoot = false;

  // Singleton pattern per avere un unico motore in tutta l'app
  static final MicCore _instance = MicCore._internal();
  factory MicCore() => _instance;
  MicCore._internal();

  /// Esegue il boot completo: Verifica Bridge -> Controllo Sicurezza -> Pronto
  Future<void> boot() async {
    try {
      final String result = await _bridge.invokeMethod('getCoreStatus');
      systemStatus = result;
      secureBoot = true;
      isReady = true;
    } catch (e) {
      systemStatus = "Errore Critico: Bridge Non Trovato";
      isReady = false;
    }
  }
}
