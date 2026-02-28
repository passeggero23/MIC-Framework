import 'package:flutter/foundation.dart';
import 'channel_manager.dart';

enum BootStatus { idle, booting, ready, error }

class BootManager {
  static final BootManager _instance = BootManager._internal();
  factory BootManager() => _instance;
  BootManager._internal();

  BootStatus _status = BootStatus.idle;
  BootStatus get status => _status;

  final List<String> _log = [];
  List<String> get bootLog => List.unmodifiable(_log);

  Future<bool> boot() async {
    try {
      _status = BootStatus.booting;
      _log.clear();

      _log.add('[BOOT] Inizializzazione Core Engine...');
      await Future.delayed(const Duration(milliseconds: 100));

      _log.add('[BOOT] Avvio Channel Manager...');
      await ChannelManager().initialize();

      _log.add('[BOOT] Sistema pronto.');
      _status = BootStatus.ready;
      return true;
    } catch (e) {
      _status = BootStatus.error;
      _log.add('[BOOT ERROR] $e');
      debugPrint('[BootManager] Errore: $e');
      return false;
    }
  }
}
