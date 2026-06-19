import 'package:flutter/material.dart';

import '../theme.dart';
import 'surah_number_badge.dart';

/// A card with a number badge, name, and ayah count, plus a flexible [trailing] control
class SurahCard extends StatelessWidget {
  final int number;
  final String name;
  final int ayahCount;
  final VoidCallback onTap;
  final Widget trailing;

  final bool mutedBadge;
  final bool dimName;
  final bool strikethrough;
  final bool faded;

  const SurahCard({
    super.key,
    required this.number,
    required this.name,
    required this.ayahCount,
    required this.onTap,
    required this.trailing,
    this.mutedBadge = false,
    this.dimName = false,
    this.strikethrough = false,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 11),
      child: Material(
        color: faded ? p.recitedTile : p.surface,
        clipBehavior: Clip.antiAlias,
        shape: p.cardShape,
        child: ListTile(
          onTap: onTap,
          title: Row(
            children: [
              SurahNumberBadge(
                number: number,
                background: mutedBadge ? p.recitedBadgeBg : p.badgeBg,
                foreground: mutedBadge ? p.recitedBadgeFg : p.badgeFg,
                borderColor: mutedBadge ? Colors.transparent : p.badgeBorder,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        color: dimName ? p.recitedName : null,
                        decoration:
                            strikethrough ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('$ayahCount ayahs', style: text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
