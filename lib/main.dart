// ... (tieni gli import precedenti)

class _MICDashboardState extends State<MICDashboard> {
  final AIEngine _aiEngine = AIEngine();
  String _aiFeedback = "Inizializzazione...";
  
  // Funzione per determinare il colore in base al feedback dell'IA
  Color _getFeedbackColor() {
    if (_aiFeedback.contains("✅")) return Colors.greenAccent;
    if (_aiFeedback.contains("⚠️")) return Colors.orangeAccent;
    if (_aiFeedback.contains("❌")) return Colors.redAccent;
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("MIC AGENT INTERFACE")),
      body: Column(
        children: [
          const Expanded(flex: 3, child: MICScanner()), // L'occhio
          
          // LA PLANCIA REATTIVA
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getFeedbackColor().withOpacity(0.1),
                border: Border(top: BorderSide(color: _getFeedbackColor(), width: 3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _aiFeedback,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _getFeedbackColor(),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
