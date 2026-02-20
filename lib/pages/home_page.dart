/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/material.dart';
import '../core/mic_core.dart';
import '../core/ai_engine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MicCore _core = MicCore();
  final AIEngine _ai = AIEngine();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initSystem();
  }

  Future<void> _initSystem() async {
    await _core.boot();
    if (mounted) setState(() {});
  }

  Future<void> _handleAIInitialization() async {
    setState(() => _isProcessing = true);
    
    // Simula un breve delay di caricamento per il feedback utente
    await Future.delayed(const Duration(milliseconds: 800));
    final success = await _ai.initialize();
    
    if (mounted) {
      setState(() => _isProcessing = false);
      _showFeedback(success);
    }
  }

  void _showFeedback(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Modulo AI Caricato" : "Errore: Modello non trovato"),
        backgroundColor: success ? Colors.blueAccent : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('MIC CONTROL PANEL', style: TextStyle(letterSpacing: 1.5, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          _buildStatusIndicator(),
          const Spacer(),
          _buildControlPanel(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Center(
      child: Column(
        children: [
          Icon(
            _core.isReady ? Icons.security_rounded : Icons.shield_outlined,
            color: _core.isReady ? Colors.blue : Colors.blueGrey,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            _core.systemStatus.toUpperCase(),
            style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handleAIInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("INITIALIZE AI ENGINE", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "AI STATUS: ${_ai.isModelLoaded ? 'READY' : 'STANDBY'}",
            style: TextStyle(
              color: _ai.isModelLoaded ? Colors.greenAccent : Colors.white30,
              fontSize: 11,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
