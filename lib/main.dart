/*
 * Copyright 2026 MIC-Framework
 * Licensed under the Apache License, Version 2.0
 */

import 'package:flutter/material.dart';
import 'main_navigation.dart';

void main() {
  runApp(const MICFramework());
}

class MICFramework extends StatelessWidget {
  const MICFramework({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC Framework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}
