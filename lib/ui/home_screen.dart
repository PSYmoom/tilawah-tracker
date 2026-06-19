import 'package:flutter/material.dart';

import '../data/memorized_store.dart';
import '../data/surah_catalog.dart';
import '../services/tarteel_launcher.dart';
import 'edit_memorized_screen.dart';
import 'theme.dart';
import 'widgets/app_header.dart';
import 'widgets/edit_list_button.dart';
import 'widgets/empty_state.dart';
import 'widgets/rotation_controls.dart';
import 'widgets/section_header.dart';
import 'widgets/surah_card.dart';

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
    final p = AppPalette.of(context);
    return Scaffold(
      floatingActionButton: EditListButton(onTap: _openEditList),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [p.backgroundTop, p.background],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: FutureBuilder<void>(
                  future: _loadFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (_store.isEmpty) return const EmptyState();

                    final dueNext = _store.dueNext;
                    final recited = _store.recitedThisCycle;

                    final rows = <Widget>[];
                    if (dueNext.isNotEmpty) {
                      rows.add(const SectionHeader('Due next'));
                      rows.addAll(
                        dueNext.map((n) => _surahTile(n, recited: false)),
                      );
                    }
                    if (recited.isNotEmpty) {
                      rows.add(
                        const SectionHeader('Recited this cycle', muted: true),
                      );
                      rows.addAll(
                        recited.map((n) => _surahTile(n, recited: true)),
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.only(top: 4, bottom: 104),
                      children: rows,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _surahTile(int number, {required bool recited}) {
    final surah = _catalog.getSurah(number);
    return SurahCard(
      number: number,
      name: surah?.name ?? 'Surah $number',
      ayahCount: surah?.ayahCount ?? 0,
      onTap: () => _toggleRecited(number),
      mutedBadge: recited,
      dimName: recited,
      strikethrough: recited,
      faded: recited,
      trailing: RotationControls(
        recited: recited,
        onOpenTarteel: () => _tarteel.openSurah(number),
      ),
    );
  }
}
