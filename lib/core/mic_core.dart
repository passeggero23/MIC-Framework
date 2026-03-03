import 'package:record/record.dart';
import 'package:flutter/foundation.dart';

class MicCore {
  static final MicCore _instance = MicCore._internal();
  factory MicCore() => _instance;
  MicCore._internal();

  String systemStatus = "Inizializzazione...";
  bool isReady = false;
  bool secureBoot = false;

  final AudioRecorder _recorder = AudioRecorder();
  bool isRecording = false;
  String audioResult = '⏳ In attesa...';

  Future<void> boot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      systemStatus = "Sistema MIC: Attivo";
      secureBoot = true;
      isReady = true;
      debugPrint('[MicCore] Boot completato');
    } catch (e) {
      systemStatus = "Errore durante il boot";
      isReady = false;
      debugPrint('[MicCore] Errore boot: $e');
    }
  }

  Future<void> startAudio() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        audioResult = '⚠️ Permesso microfono negato';
        return;
      }
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.pcm16bits),
        path: '',
      );
      isRecording = true;
      debugPrint('[MicCore] Microfono avviato');
    } catch (e) {
      audioResult = '❌ Errore microfono';
      debugPrint('[MicCore] Errore audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _recorder.stop();
      isRecording = false;
      audioResult = '✅ Audio registrato';
    } catch (e) {
      debugPrint('[MicCore] Errore stop audio: $e');
    }
  }

  void dispose() {
    _recorder.dispose();
    isRecording = false;
  }
}
Poi aggiorna lib/core/vision_module.dart → matita → sostituisci tutto:
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MICScanner extends StatefulWidget {
  const MICScanner({super.key});

  @override
  State<MICScanner> createState() => _MICScannerState();
}

class _MICScannerState extends State<MICScanner> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller?.initialize();
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }
    return CameraPreview(_controller!);
  }
}
