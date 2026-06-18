import 'package:flutter/material.dart';

import 'ui/home_screen.dart';

void main() {
  runApp(const TilawahApp());
}

class TilawahApp extends StatelessWidget {
  const TilawahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TilawahTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B6B5A)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
