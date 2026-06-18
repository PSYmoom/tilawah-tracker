import 'package:flutter/material.dart';

import '../data/memorized_store.dart';
import '../data/surah.dart';
import 'widgets/surah_check_tile.dart';

/// Lets the user pick which surahs they've memorized
class EditMemorizedScreen extends StatefulWidget {
  final MemorizedStore store;
  final List<Surah> allSurahs;

  const EditMemorizedScreen({
    super.key,
    required this.store,
    required this.allSurahs,
  });

  @override
  State<EditMemorizedScreen> createState() => _EditMemorizedScreenState();
}

class _EditMemorizedScreenState extends State<EditMemorizedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit memorized list')),
      body: ListView.builder(
        itemCount: widget.allSurahs.length,
        itemBuilder: (context, index) {
          final surah = widget.allSurahs[index];
          return SurahCheckTile(
            surah: surah,
            checked: widget.store.isMemorized(surah.number),
            onChanged: (checked) => _setMemorized(surah, checked),
          );
        },
      ),
    );
  }

  Future<void> _setMemorized(Surah surah, bool memorized) async {
    if (memorized) {
      await widget.store.addMemorized(surah.number);
    } else {
      await widget.store.removeMemorized(surah.number);
    }
    if (mounted) setState(() {});
  }
}
