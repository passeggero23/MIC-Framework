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

  Future<void> _handleAI() async {
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
              size: 80,
              color: _ai.isModelLoaded ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleAI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.2),
              ),
              child: Text(_isProcessing ? "ELABORAZIONE..." : "ATTIVA MOTORE IA"),
            ),
          ],
        ),
      ),
    );
  }
}
