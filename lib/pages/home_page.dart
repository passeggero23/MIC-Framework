import 'package:flutter/material.dart';
import '../core/mic_core.dart'; // Importiamo il motore che hai appena creato

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Istanziamo il Core
  final MicCore _core = MicCore();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _bootstrapFramework();
  }

  // Funzione per avviare il motore al lancio dell'app
  Future<void> _bootstrapFramework() async {
    await _core.boot();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIC Framework Dashboard'),
        actions: [
          Icon(
            _core.isSecure ? Icons.shield : Icons.shield_outlined,
            color: _core.isSecure ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: _isLoading 
          ? const CircularProgressIndicator() // Caricamento durante il boot
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Stato del Sistema:",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  _core.systemStatus,
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: _core.isSecure ? Colors.blue : Colors.orange,
                  ),
                ),
                const SizedBox(height: 40),
                if (_core.isSecure)
                  const Icon(Icons.check_circle, color: Colors.green, size: 60)
              ],
            ),
      ),
    );
  }
}
