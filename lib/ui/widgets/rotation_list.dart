import 'package:flutter/material.dart';

import '../../data/surah_catalog.dart';
import 'rotation_controls.dart';
import 'section_header.dart';
import 'surah_card.dart';

/// The rotation as two sections: "Due next" on top, "Recited this cycle" below.
class RotationList extends StatelessWidget {
  final List<int> dueNext;
  final List<int> recited;
  final SurahCatalog catalog;
  final void Function(int surahNumber) onToggle;
  final void Function(int surahNumber) onOpenTarteel;

  const RotationList({
    super.key,
    required this.dueNext,
    required this.recited,
    required this.catalog,
    required this.onToggle,
    required this.onOpenTarteel,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (dueNext.isNotEmpty) {
      rows.add(const SectionHeader('Due next'));
      rows.addAll(dueNext.map((n) => _tile(n, recited: false)));
    }
    if (recited.isNotEmpty) {
      rows.add(const SectionHeader('Recited this cycle', muted: true));
      rows.addAll(recited.map((n) => _tile(n, recited: true)));
    }
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 104),
      children: rows,
    );
  }

  Widget _tile(int number, {required bool recited}) {
    final surah = catalog.getSurah(number);
    return SurahCard(
      number: number,
      name: surah?.name ?? 'Surah $number',
      ayahCount: surah?.ayahCount ?? 0,
      onTap: () => onToggle(number),
      mutedBadge: recited,
      dimName: recited,
      strikethrough: recited,
      faded: recited,
      trailing: RotationControls(
        recited: recited,
        onOpenTarteel: () => onOpenTarteel(number),
      ),
    );
  }
}
