import 'package:flutter/material.dart';
import 'package:mic_app/main_navigation.dart';

void main() {
  runApp(const MicApp());
}

class MicApp extends StatelessWidget {
  const MicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC APP',
      theme: ThemeData(useMaterial3: true),
      home: const MainNavigation(),
    );
  }
}
