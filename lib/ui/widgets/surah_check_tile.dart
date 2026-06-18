import 'package:flutter/material.dart';

import '../../data/surah.dart';

/// A checkbox row used on the Edit screen to add/remove a surah from the
/// memorized list. It's "dumb": it just shows the surah and a checkbox, and
/// reports toggles via [onChanged] — the screen decides what to do with them.
class SurahCheckTile extends StatelessWidget {
  final Surah surah;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const SurahCheckTile({
    super.key,
    required this.surah,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: checked,
      secondary: CircleAvatar(child: Text('${surah.number}')),
      title: Text(surah.name),
      subtitle: Text('${surah.ayahCount} ayahs'),
      onChanged: (value) => onChanged(value ?? false),
    );
  }
}
