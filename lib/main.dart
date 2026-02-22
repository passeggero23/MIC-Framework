import 'package:flutter/material.dart';
import 'core/ai_engine.dart';
import 'core/vision_module.dart';

void main() => runApp(const MICAgentApp());

class MICAgentApp extends StatelessWidget {
  const MICAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
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
  final AIEngine _engine = AIEngine();
  String _currentFeedback = "Inizializzazione Agente...";

  @override
  void initState() {
    super.initState();
    _engine.initialize();
  }

  Color _getUIStatusColor() {
    if (_currentFeedback.contains("✅")) return Colors.greenAccent;
    if (_currentFeedback.contains("⚠️")) return Colors.orangeAccent;
    if (_currentFeedback.contains("❌")) return Colors.redAccent;
    return Colors.blueAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MIC-FRAMEWORK AGENT"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Expanded(flex: 4, child: MICScanner()),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              // CORREZIONE QUI: Usiamo un metodo più stabile per la trasparenza
              color: _getUIStatusColor().withAlpha(25), 
              border: Border(top: BorderSide(color: _getUIStatusColor(), width: 2)),
            ),
            child: Text(
              _currentFeedback,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _getUIStatusColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
