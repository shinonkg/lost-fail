import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KayipDosyalarApp());
}

class KayipDosyalarApp extends StatelessWidget {
  const KayipDosyalarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayıp Dosyalar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffb88a44),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff111111),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
