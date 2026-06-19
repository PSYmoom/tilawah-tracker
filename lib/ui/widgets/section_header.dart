import 'package:flutter/material.dart';

import '../theme.dart';

/// A small uppercase heading labelling a section of the rotation list
class SectionHeader extends StatelessWidget {
  final String label;
  final bool muted;

  const SectionHeader(this.label, {super.key, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: muted ? p.sectionDone : p.sectionDue),
      ),
    );
  }
}
