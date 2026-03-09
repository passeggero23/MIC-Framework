  String statusMessage = "Inizializzazione...";

  Future<void> _initializeEngine() async {
    try {
      setState(() => statusMessage = "Caricamento Modello...");
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      
      setState(() => statusMessage = "Caricamento Label...");
      final labelData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelData.split('\n');

      setState(() => statusMessage = "Avvio Camera...");
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      
      if (!mounted) return;
      setState(() => statusMessage = "Pronto!");
    } catch (e) {
      setState(() => statusMessage = "ERRORE: ${e.toString()}");
      debugPrint("Errore critico: $e");
    }
  }
