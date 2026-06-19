import 'package:flutter/material.dart';

import '../theme.dart';

/// Shown on the home screen when the user hasn't added any memorized surahs.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 56, color: p.ornament),
            const SizedBox(height: 18),
            Text(
              'No memorized surahs yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap 'Edit list' to add the surahs you've memorized.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: p.ayahs, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
