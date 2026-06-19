import 'package:flutter/material.dart';

import 'ui/home_screen.dart';
import 'ui/theme.dart';

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
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
