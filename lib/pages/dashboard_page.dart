import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessario per comunicare con il Kotlin

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Definiamo lo stesso canale creato in MainActivity.kt
  static const platform = MethodChannel('com.mic.framework/inference');
  
  String _coreStatus = "In attesa di connessione...";

  // Funzione per interrogare il cuore nativo
  Future<void> _checkCoreStatus() async {
    try {
      final String result = await platform.invokeMethod('getCoreStatus');
      setState(() {
        _coreStatus = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _coreStatus = "Errore comunicazione: ${e.message}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkCoreStatus(); // Controlla lo stato appena la pagina si carica
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIC Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.memory, size: 64, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "Stato Sistema:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _coreStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            ElevatedButton(
              onPressed: _checkCoreStatus,
              child: const Text("Aggiorna Stato AI"),
            ),
          ],
        ),
      ),
    );
  }
}
