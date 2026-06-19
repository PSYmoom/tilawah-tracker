import 'package:flutter/material.dart';

import '../data/memorized_store.dart';
import '../data/surah.dart';
import 'theme.dart';
import 'widgets/surah_card.dart';
import 'widgets/surah_checkbox.dart';

/// Lets the user pick which surahs they've memorized
class EditMemorizedScreen extends StatefulWidget {
  final MemorizedStore store;
  final List<Surah> allSurahs;

  const EditMemorizedScreen({
    super.key,
    required this.store,
    required this.allSurahs,
  });

  @override
  State<EditMemorizedScreen> createState() => _EditMemorizedScreenState();
}

class _EditMemorizedScreenState extends State<EditMemorizedScreen> {
  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final memorizedCount =
        widget.allSurahs.where((s) => widget.store.isMemorized(s.number)).length;

    return Scaffold(
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
              _EditHeader(
                memorized: memorizedCount,
                total: widget.allSurahs.length,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: widget.allSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = widget.allSurahs[index];
                    final checked = widget.store.isMemorized(surah.number);
                    return SurahCard(
                      number: surah.number,
                      name: surah.name,
                      ayahCount: surah.ayahCount,
                      onTap: () => _setMemorized(surah, !checked),
                      mutedBadge: !checked,
                      trailing: SurahCheckbox(checked: checked),
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

  Future<void> _setMemorized(Surah surah, bool memorized) async {
    if (memorized) {
      await widget.store.addMemorized(surah.number);
    } else {
      await widget.store.removeMemorized(surah.number);
    }
    if (mounted) setState(() {});
  }
}

class _EditHeader extends StatelessWidget {
  final int memorized;
  final int total;
  final VoidCallback onBack;

  const _EditHeader({
    required this.memorized,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: p.name),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Edit list', style: text.headlineSmall),
                const SizedBox(height: 2),
                Text(
                  '$memorized of $total memorized',
                  style: text.bodySmall?.copyWith(color: p.ornament),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // balance the back button to centre the title
        ],
      ),
    );
  }
}
