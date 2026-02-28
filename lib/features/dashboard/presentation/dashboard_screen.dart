/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mic_core.dart';
import '../../../core/vision_module.dart';

final systemStatusProvider = StateProvider<String>((ref) => 'Inizializzazione...');
final isReadyProvider = StateProvider<bool>((ref) => false);
final isRecordingProvider = StateProvider<bool>((ref) => false);
final audioResultProvider = StateProvider<String>((ref) => '⏳ In attesa...');

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final core = MicCore();
    await core.boot();
    ref.read(systemStatusProvider.notifier).state = core.systemStatus;
    ref.read(isReadyProvider.notifier).state = core.isReady;
  }

  Future<void> _toggleAudio() async {
    final core = MicCore();
    if (!core.isRecording) {
      await core.startAudio();
    } else {
      await core.stopAudio();
      ref.read(audioResultProvider.notifier).state = core.audioResult;
    }
    ref.read(isRecordingProvider.notifier).state = core.isRecording;
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(systemStatusProvider);
    final isReady = ref.watch(isReadyProvider);
    final isRecording = ref.watch(isRecordingProvider);
    final audioResult = ref.watch(audioResultProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: const Text(
          'MIC Framework',
          style: TextStyle(
            color: Colors.cyanAccent,
            letterSpacing: 2,
            fontFamily: 'monospace',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(
                  color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      Icons.circle,
                      color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(
                      Icons.mic,
                      color: isRecording ? Colors.redAccent : Colors.grey,
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      audioResult,
                      style: TextStyle(
                        color: isRecording ? Colors.redAccent : Colors.cyanAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Camera
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const MICScanner(),
              ),
            ),
            const SizedBox(height: 16),
            // Mic Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isReady ? _toggleAudio : null,
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                label: Text(isRecording ? 'STOP AUDIO' : 'AVVIA AUDIO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isRecording ? Colors.redAccent : Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
