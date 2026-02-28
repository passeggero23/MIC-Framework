/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'ai_engine.dart';

class MicCore {
  static final MicCore _instance = MicCore._internal();
  factory MicCore() => _instance;
  MicCore._internal();

  String systemStatus = "Inizializzazione...";
  bool isReady = false;
  bool secureBoot = false;

  final AudioRecorder _recorder = AudioRecorder();
  bool isRecording = false;
  String audioResult = '⏳ In attesa...';

  Future<void> boot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await AIEngine().initialize();
      systemStatus = "Sistema MIC: Attivo";
      secureBoot = true;
      isReady = true;
      debugPrint('[MicCore] Boot completato');
    } catch (e) {
      systemStatus = "Errore durante il boot";
      isReady = false;
      debugPrint('[MicCore] Errore boot: $e');
    }
  }

  Future<void> startAudio() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        audioResult = '⚠️ Permesso microfono negato';
        return;
      }
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.pcm16bits),
        path: '',
      );
      isRecording = true;
      debugPrint('[MicCore] Microfono avviato');
    } catch (e) {
      audioResult = '❌ Errore microfono';
      debugPrint('[MicCore] Errore audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _recorder.stop();
      isRecording = false;
      final result = AIEngine().analyzeAudio([]);
      audioResult = result.isNotEmpty ? '✅ Audio elaborato' : '⚠️ Nessun risultato';
    } catch (e) {
      debugPrint('[MicCore] Errore stop audio: $e');
    }
  }

  void dispose() {
    _recorder.dispose();
    isRecording = false;
  }
}
