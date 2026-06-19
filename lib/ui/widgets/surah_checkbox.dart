import 'package:flutter/material.dart';

import '../theme.dart';

/// A small brass checkbox used as the trailing control on the edit screen.
/// Display-only: the surrounding [SurahCard]'s tap toggles the value.
class SurahCheckbox extends StatelessWidget {
  final bool checked;

  const SurahCheckbox({super.key, required this.checked});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: checked ? p.ornament : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: checked
            ? null
            : Border.all(color: p.ornament.withValues(alpha: 0.5), width: 1.7),
      ),
      child: checked ? Icon(Icons.check, size: 16, color: p.onFab) : null,
    );
  }
}
