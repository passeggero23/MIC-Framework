/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'ai_engine.dart';

class AudioModule {
  static final AudioModule _instance = AudioModule._internal();
  factory AudioModule() => _instance;
  AudioModule._internal();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  String lastResult = '⏳ In attesa...';

  Future<void> start() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        lastResult = '⚠️ Permesso microfono negato';
        return;
      }
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.pcm16bits),
        path: '',
      );
      _isRecording = true;
      debugPrint('[AudioModule] Registrazione avviata');
    } catch (e) {
      debugPrint('[AudioModule] Errore start: $e');
      lastResult = '❌ Errore microfono';
    }
  }

  Future<void> stop() async {
    try {
      await _recorder.stop();
      _isRecording = false;
      final result = AIEngine().analyzeAudio([]);
      lastResult = result.isNotEmpty ? '✅ Audio elaborato' : '⚠️ Nessun risultato';
      debugPrint('[AudioModule] Registrazione fermata');
    } catch (e) {
      debugPrint('[AudioModule] Errore stop: $e');
    }
  }

  void dispose() {
    _recorder.dispose();
    _isRecording = false;
  }
}
