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
  String _performance = "N/A";

  Future<void> _handleAIInitialization() async {
    setState(() => _isProcessing = true);
    await _ai.initialize();
    setState(() => _isProcessing = false);
  }

  void _runDiagnostic() {
    final watch = Stopwatch()..start();
    _ai.runInference([1.0, 0.5, 0.0]);
    watch.stop();
    setState(() {
      _performance = "${watch.elapsedMicroseconds / 1000} ms";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIC Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 80, color: _ai.isModelLoaded ? Colors.greenAccent : Colors.redAccent),
            const SizedBox(height: 10),
            Text("ENGINE STATUS: ${_ai.isModelLoaded ? 'ONLINE' : 'OFFLINE'}"),
            Text("LATENCY: $_performance"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleAIInitialization,
              child: const Text("INITIALIZE ENGINE"),
            ),
            if (_ai.isModelLoaded) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _runDiagnostic,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.2)),
                child: const Text("RUN DIAGNOSTIC"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
