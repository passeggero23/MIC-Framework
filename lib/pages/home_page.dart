/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/material.dart';
import '../core/mic_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MicCore _core = MicCore();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _core.boot();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('MIC CORE'), 
        centerTitle: true, 
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
        // CORREZIONE RIGA 57: Usiamo withValues invece di withOpacity
        border: Border.all(
          color: _core.isReady 
              ? Colors.blue.withValues(alpha: 0.5) 
              : Colors.red.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _core.isReady ? Icons.bolt_rounded : Icons.warning_rounded, 
            color: _core.isReady ? Colors.blue : Colors.red, 
            size: 64
          ),
          const SizedBox(height: 16),
          Text(
            _core.isReady ? "SISTEMA ATTIVO" : "OFFLINE", 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
            )
          ),
          const SizedBox(height: 8),
          Text(
            _core.systemStatus, 
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14)
          ),
        ],
      ),
    );
  }
}
