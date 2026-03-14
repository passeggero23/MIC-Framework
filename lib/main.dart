import 'package:flutter/material.dart';

void main() {
  runApp(const MicApp());
}

class MicApp extends StatelessWidget {
  const MicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC Framework',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIC Framework'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              '✅ Build Base Funzionante',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            SizedBox(height: 10),
            Text(
              'Pronto per aggiungere AI',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
