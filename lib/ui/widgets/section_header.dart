import 'package:flutter/material.dart';

/// A small uppercase heading used to label sections of the rotation list
/// ("DUE NEXT", "RECITED THIS CYCLE").
class SectionHeader extends StatelessWidget {
  final String label;

  const SectionHeader(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
