import 'package:flutter/material.dart';

import '../theme.dart';

/// The home screen's header: a crescent flourish, the app title, and a tagline.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
      child: Column(
        children: [
          Icon(Icons.brightness_3, size: 15, color: p.ornament),
          const SizedBox(height: 8),
          Text(
            'Tilawah Tracker',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 3),
          Text(
            'Your memorized rotation',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: p.tagline, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}
