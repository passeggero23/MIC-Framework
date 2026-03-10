  Future<void> _initializeEngine() async {
    try {
      setState(() => statusMessage = "Estrazione dati modello...");
      // Leggiamo i byte grezzi del file da 6.55 MB
      final modelData = await DefaultAssetBundle.of(context).load('assets/model.tflite');
      
      setState(() => statusMessage = "Inizializzazione Buffer IA...");
      // Carichiamo l'interprete dai byte direttamente
      _interpreter = Interpreter.fromBuffer(modelData.buffer.asUint8List());
      
      setState(() => statusMessage = "Caricamento Label...");
      final labelData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelData.split('\n');

      setState(() => statusMessage = "Avvio Camera...");
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      setState(() => statusMessage = "Pronto!");
    } catch (e) {
      // Se c'è un errore qui, significa che il file da 6.55MB ha un formato interno non supportato
      setState(() => statusMessage = "ERRORE FORMATO:\n${e.toString()}");
    }
  }
