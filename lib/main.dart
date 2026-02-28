import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MicApp(),
    ),
  );
}

class MicApp extends StatelessWidget {
  const MicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC Framework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const DashboardScreen(),
    );
  }
}
