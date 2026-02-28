/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'ai_engine.dart';

class MICScanner extends StatefulWidget {
  const MICScanner({super.key});

  @override
  State<MICScanner> createState() => _MICScannerState();
}

class _MICScannerState extends State<MICScanner> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String _result = '⏳ In attesa...';

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller?.initialize();
      if (!mounted) return;
      setState(() {});
      _controller?.startImageStream((CameraImage image) {
        final result = AIEngine().analyzeFrame([]);
        if (result.isNotEmpty) {
          setState(() {
            _result = '✅ Frame elaborato';
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }
    return Stack(
      children: [
        CameraPreview(_controller!),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Text(
              _result,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
