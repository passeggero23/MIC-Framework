// Copyright (c) 2026 MIC-Framework.
// Licensed under the MIT License.
// Protected under MIC Ethical AI Policy (Privacy & Child Safety).

import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MicFramework());
}

class MicFramework extends StatelessWidget {
  const MicFramework({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC Framework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}
