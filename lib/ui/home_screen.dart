import 'package:flutter/material.dart';

import '../data/memorized_store.dart';
import '../data/surah_catalog.dart';
import '../services/tarteel_launcher.dart';
import 'edit_memorized_screen.dart';
import 'widgets/empty_state.dart';
import 'widgets/section_header.dart';
import 'widgets/surah_tile.dart';

/// Shows the user's memorized surahs as a round-robin rotation:
/// "Due next" (not recited this cycle) on top, "Recited this cycle" below.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MemorizedStore _store = MemorizedStore();
  final SurahCatalog _catalog = SurahCatalog();
  final TarteelLauncher _tarteel = TarteelLauncher();

  late final Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _load();
  }

  Future<void> _load() async {
    await _store.load();
    await _catalog.load();
  }

  Future<void> _openEditList() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EditMemorizedScreen(store: _store, allSurahs: _catalog.all),
      ),
    );
    // Rebuild after returning, since the memorized list may have changed.
    if (mounted) setState(() {});
  }

  Future<void> _toggleRecited(int surahNumber) async {
    final cycleCompleted = await _store.toggleRecited(surahNumber);
    if (!mounted) return;
    setState(() {});
    if (cycleCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full cycle complete — starting again 🎉'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TilawahTracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditList,
        icon: const Icon(Icons.edit),
        label: const Text('Edit list'),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (_store.isEmpty) {
            return const EmptyState();
          }

          final dueNext = _store.dueNext;
          final recited = _store.recitedThisCycle;

          final rows = <Widget>[];
          if (dueNext.isNotEmpty) {
            rows.add(const SectionHeader('Due next'));
            rows.addAll(
              dueNext.map(
                (n) => SurahTile(
                  number: n,
                  surah: _catalog.getSurah(n),
                  recited: false,
                  onTap: () => _toggleRecited(n),
                  onOpenTarteel: () => _tarteel.openSurah(n),
                ),
              ),
            );
          }
          if (recited.isNotEmpty) {
            rows.add(const SectionHeader('Recited this cycle'));
            rows.addAll(
              recited.map(
                (n) => SurahTile(
                  number: n,
                  surah: _catalog.getSurah(n),
                  recited: true,
                  onTap: () => _toggleRecited(n),
                  onOpenTarteel: () => _tarteel.openSurah(n),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 88), // clear the FAB
            children: rows,
          );
        },
      ),
    );
  }
}
