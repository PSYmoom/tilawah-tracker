import 'package:flutter/material.dart';

import '../../data/surah.dart';

/// A single row in the rotation list: the surah's number, name, ayah count,
/// and a recited indicator. Tapping it toggles the recited state.
class SurahTile extends StatelessWidget {
  final int number;
  final Surah? surah;
  final bool recited;
  final VoidCallback onTap;

  const SurahTile({
    super.key,
    required this.number,
    required this.surah,
    required this.recited,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: CircleAvatar(child: Text('$number')),
      title: Text(
        surah?.name ?? 'Surah $number',
        style: recited
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text('${surah?.ayahCount ?? 0} ayahs'),
      trailing: Icon(
        recited ? Icons.check_circle : Icons.radio_button_unchecked,
        color: recited ? primary : null,
      ),
      onTap: onTap,
    );
  }
}
