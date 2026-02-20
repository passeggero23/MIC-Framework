/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/material.dart';
import '../core/ai_engine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AIEngine _ai = AIEngine();
  bool _isProcessing = false;

  Future<void> _handleAIInitialization() async {
    setState(() => _isProcessing = true);
    await _ai.initialize();
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIC Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield,
              size: 100,
              color: _ai.isModelLoaded ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text("AI ENGINE: ${_ai.isModelLoaded ? 'READY' : 'OFFLINE'}"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleAIInitialization,
              child: Text(_isProcessing ? "INITIALIZING..." : "INITIALIZE AI ENGINE"),
            ),
          ],
        ),
      ),
    );
  }
}
