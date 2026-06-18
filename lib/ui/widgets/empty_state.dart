import 'package:flutter/material.dart';

/// Shown on the home screen when the user hasn't added any memorized surahs.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 64),
            const SizedBox(height: 16),
            Text(
              'No memorized surahs yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap 'Edit list' to add the surahs you've memorized.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
