import 'package:flutter/material.dart';

import '../data/memorized_store.dart';
import '../data/surah_catalog.dart';
import '../services/tarteel_launcher.dart';
import 'edit_memorized_screen.dart';
import 'theme.dart';
import 'widget_launch_mixin.dart';
import 'widgets/app_header.dart';
import 'widgets/edit_list_button.dart';
import 'widgets/empty_state.dart';
import 'widgets/rotation_list.dart';

/// Shows the user's memorized surahs as a round-robin rotation:
/// "Due next" (not recited this cycle) on top, "Recited this cycle" below.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetLaunchMixin<HomeScreen> {
  final MemorizedStore _store = MemorizedStore();
  final SurahCatalog _catalog = SurahCatalog();
  final TarteelLauncher _tarteel = TarteelLauncher();

  late final Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _load();
    initWidgetLaunch();
  }

  @override
  void dispose() {
    disposeWidgetLaunch();
    super.dispose();
  }

  // --- WidgetLaunchMixin hooks ---

  @override
  Future<void> get launchReady => _loadFuture;

  @override
  Future<void> onAppResumed() async {
    await _store.load();
    if (mounted) setState(() {});
  }

  @override
  void onWidgetLaunch(String host) {
    // Reset to a known screen so the widget always lands deterministically.
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (host == 'edit') _openEditList();
  }

  // --- Screen logic ---

  Future<void> _load() async {
    await _store.load();
    await _catalog.load();
    syncWidget();
  }

  Future<void> _openEditList() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EditMemorizedScreen(store: _store, allSurahs: _catalog.all),
      ),
    );
    if (mounted) setState(() {});
    syncWidget();
  }

  Future<void> _toggleRecited(int surahNumber) async {
    final cycleCompleted = await _store.toggleRecited(surahNumber);
    if (!mounted) return;
    setState(() {});
    syncWidget();
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
                    return RotationList(
                      dueNext: _store.dueNext,
                      recited: _store.recitedThisCycle,
                      catalog: _catalog,
                      onToggle: _toggleRecited,
                      onOpenTarteel: _tarteel.openSurah,
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
}
