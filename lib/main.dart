import 'package:flutter/material.dart';
import 'core/ai_engine.dart';          // Importiamo il cervello
import 'core/vision_module.dart';      // Importiamo l'occhio

void main() {
  runApp(const MICFrameworkApp());
}

class MICFrameworkApp extends StatelessWidget {
  const MICFrameworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Look futuristico per il MIC
      home: const MICDashboard(),
    );
  }
}

class MICDashboard extends StatefulWidget {
  const MICDashboard({super.key});

  @override
  State<MICDashboard> createState() => _MICDashboardState();
}

class _MICDashboardState extends State<MICDashboard> {
  final AIEngine _aiEngine = AIEngine(); // Inizializziamo il motore

  @override
  void initState() {
    super.initState();
    _aiEngine.initialize(); // Facciamo partire il riscaldamento dell'IA
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIC-Framework Dashboard")),
      body: Column(
        children: [
          // 1. Il Modulo di Visione (Lo Scanner)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.greenAccent, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: const MICScanner(), // Qui appare la fotocamera!
            ),
          ),
          
          // 2. Pannello di Controllo IA
          const Expanded(
            child: Center(
              child: Text(
                "SISTEMA IA ATTIVO\nIn attesa di analisi...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.greenAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
