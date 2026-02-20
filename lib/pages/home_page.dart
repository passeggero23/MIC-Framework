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
    _initFramework();
  }

  Future<void> _initFramework() async {
    await _core.boot();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('MIC FRAMEWORK CORE'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            const Text("MODULI ATTIVI", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            const Expanded(child: Center(child: Text("Nessun modulo IA caricato", style: TextStyle(color: Colors.white24)))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _core.isReady ? Colors.blue.withOpacity(0.5) : Colors.red),
      ),
      child: Row(
        children: [
          Icon(_core.isReady ? Icons.bolt : Icons.warning, color: _core.isReady ? Colors.blue : Colors.red, size: 40),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_core.isReady ? "SISTEMA ATTIVO" : "SISTEMA OFFLINE", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(_core.systemStatus, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
