import 'package:flutter/material.dart';

import '../theme.dart';

/// The trailing controls for a rotation row: a "recite in Tarteel" button and the recited indicator
class RotationControls extends StatelessWidget {
  final bool recited;
  final VoidCallback onOpenTarteel;

  const RotationControls({
    super.key,
    required this.recited,
    required this.onOpenTarteel,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TarteelButton(
          background: recited ? p.recitedReciteBg : p.reciteBg,
          foreground: recited ? p.recitedReciteFg : p.reciteFg,
          onTap: onOpenTarteel,
        ),
        const SizedBox(width: 4),
        Icon(
          recited ? Icons.check_circle : Icons.circle_outlined,
          color: p.status,
          size: 22,
        ),
      ],
    );
  }
}

/// The circular "recite in Tarteel" button.
class _TarteelButton extends StatelessWidget {
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _TarteelButton({
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Recite in Tarteel',
      child: SizedBox(
        width: 40,
        height: 40,
        child: Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Icon(Icons.play_arrow_rounded, color: foreground, size: 23),
          ),
        ),
      ),
    );
  }
}
