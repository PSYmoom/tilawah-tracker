import 'package:flutter/material.dart';

import 'data/surah.dart';

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
      home: const SurahListScreen(),
    );
  }
}

/// Shows all 114 surahs in a scrollable list.
class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  // We load the surahs once, when the screen is first created, and remember
  // the resulting Future so the list isn't re-read on every rebuild.
  late final Future<List<Surah>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = loadSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TilawahTracker'),
      ),
      // FutureBuilder rebuilds itself as the Future progresses: first while
      // loading, then once the data (or an error) is ready.
      body: FutureBuilder<List<Surah>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load surahs: ${snapshot.error}'),
            );
          }
          final surahs = snapshot.data!;
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${surah.number}'),
                ),
                title: Text(surah.name),
                subtitle: Text('${surah.ayahCount} ayahs'),
              );
            },
          );
        },
      ),
    );
  }
}
