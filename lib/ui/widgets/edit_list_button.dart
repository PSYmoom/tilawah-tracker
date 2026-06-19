import 'package:flutter/material.dart';

import '../theme.dart';

/// The gradient "Edit list" button shown as the home screen's floating action.
/// Opens the screen for adding/removing memorized surahs.
class EditListButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditListButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.fabStart, p.fabEnd],
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: p.fabEnd.withValues(alpha: 0.45),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kCardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_outlined, size: 18, color: p.onFab),
                const SizedBox(width: 9),
                Text(
                  'Edit list',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: p.onFab),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
