import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _aiEnhanced = true;
  double _threshold = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIC Settings")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("CONFIGURAZIONE CORE", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          SwitchListTile(
            title: const Text("AI Enhanced Mode"),
            subtitle: const Text("Attiva l'inferenza avanzata sul chip neurale"),
            value: _aiEnhanced,
            onChanged: (bool value) => setState(() => _aiEnhanced = value),
          ),
          const Divider(),
          const ListTile(
            title: Text("Soglia di Confidenza"),
            subtitle: Text("Livello minimo per la validazione decisionale"),
          ),
          Slider(
            value: _threshold,
            divisions: 10,
            label: _threshold.toString(),
            onChanged: (double value) => setState(() => _threshold = value),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Versione Framework"),
            trailing: const Text("1.0.0+1"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "MIC Framework",
                applicationVersion: "1.0.0+1",
                children: [const Text("Sviluppato per suite decisionali avanzate.")],
              );
            },
          ),
        ],
      ),
    );
  }
}
