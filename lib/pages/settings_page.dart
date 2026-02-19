/*
 * Copyright (c) 2026 Passeggero23
 * Licensed under the Apache License, Version 2.0
 */
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Impostazioni',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
