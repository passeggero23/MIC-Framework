  /// Esegue il boot completo: Simulazione Bridge per Fase Sviluppo
  Future<void> boot() async {
    try {
      // Commentiamo la chiamata reale finché non configureremo le cartelle /android e /ios
      // final String result = await _bridge.invokeMethod('getCoreStatus'); 
      
      await Future.delayed(const Duration(seconds: 1)); // Simula caricamento
      systemStatus = "Sistema Operativo MIC: Attivo";
      secureBoot = true;
      isReady = true;
    } catch (e) {
      systemStatus = "Errore Bridge: Modalità Simulazione Attiva";
      isReady = true; // Permettiamo comunque l'uso dell'app
    }
  }
