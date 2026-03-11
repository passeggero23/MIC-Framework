// Il file si chiama mic_app (minuscolo)
// Ma la classe si chiama MicApp (maiuscolo)

class MicApp extends StatelessWidget {
  const MicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIC APP', // Questo è il nome che apparirà sul telefono
      theme: ThemeData(useMaterial3: true),
      home: const MainNavigation(), // Qui colleghiamo la tua vera navigazione
    );
  }
}
