/*
 * Copyright (c) 2026 Passeggero23
 * Licensed under the Apache License, Version 2.0
 */
import 'package:flutter/material.dart';
import 'main_navigation.dart';

void main() {
  runApp(const MICFrameworkApp());
}

class MICFrameworkApp extends StatelessWidget {
  const MICFrameworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC Framework',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}
