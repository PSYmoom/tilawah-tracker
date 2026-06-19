import 'package:flutter/material.dart';

/// The rounded-square badge showing a surah's number
class SurahNumberBadge extends StatelessWidget {
  final int number;
  final Color background;
  final Color foreground;
  final Color borderColor;

  const SurahNumberBadge({
    super.key,
    required this.number,
    required this.background,
    required this.foreground,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Text(
        '$number',
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: foreground),
      ),
    );
  }
}
