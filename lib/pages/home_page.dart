import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MIC FRAMEWORK CORE"),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // Due colonne
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuCard(
              context, 
              "DASHBOARD", 
              Icons.analytics_outlined, 
              Colors.blue,
              const DashboardPage()
            ),
            _buildMenuCard(
              context, 
              "AI ENGINE", 
              Icons.psychology_outlined, 
              Colors.purple,
              null // Modulo futuro
            ),
            _buildMenuCard(
              context, 
              "DATABASE", 
              Icons.storage_rounded, 
              Colors.amber,
              null // Modulo futuro
            ),
            _buildMenuCard(
              context, 
              "SETTINGS", 
              Icons.settings_suggest_outlined, 
              Colors.grey,
              const SettingsPage()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget? destination) {
    return InkWell(
      onTap: () {
        if (destination != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title: Modulo in fase di sviluppo..."))
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
