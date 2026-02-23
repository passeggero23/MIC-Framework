// Aggiungi questa funzione sotto setup()
  Future<void> analizza() async {
    if (controller == null || !controller!.value.isInitialized) return;

    setState(() => status = "Analisi in corso...");
    
    try {
      // Scatta una foto temporanea per l'analisi
      final image = await controller!.takePicture();
      
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.2,
      );

      setState(() {
        if (recognitions != null && recognitions.isNotEmpty) {
          status = "Vedo: ${recognitions[0]['label']}";
        } else {
          status = "Non riconosco nulla";
        }
      });
    } catch (e) {
      setState(() => status = "Errore analisi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(body: Center(child: Text(status)));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          // Tasto per analizzare
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black87,
                  child: Text(status, style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: analizza,
                  child: const Text("COSA VEDI?"),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
