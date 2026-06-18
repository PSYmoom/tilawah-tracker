import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

/// Tracks the user's memorized surahs as a round-robin rotation.
///
/// Two sets are kept (and persisted to device storage):
///  - [_memorized]: the surah numbers the user has memorized. A SplayTreeSet
///    keeps these sorted by number at all times, so we never sort for display.
///  - [_recited]:   the ones already recited in the CURRENT cycle. Only ever
///    queried by membership (contains), so a plain HashSet (O(1)) is fine.
class MemorizedStore {
  static const _memorizedKey = 'memorized';
  static const _recitedKey = 'recited_this_cycle';

  final SplayTreeSet<int> _memorized = SplayTreeSet<int>();
  final Set<int> _recited = {};

  /// Loads saved data from disk into memory. Call once at startup.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _memorized
      ..clear()
      ..addAll((prefs.getStringList(_memorizedKey) ?? []).map(int.parse));
    _recited
      ..clear()
      ..addAll((prefs.getStringList(_recitedKey) ?? []).map(int.parse));
    // Safety: never keep a "recited" entry that isn't in the memorized list.
    _recited.removeWhere((n) => !_memorized.contains(n));
  }

  bool get isEmpty => _memorized.isEmpty;

  bool isMemorized(int surahNumber) => _memorized.contains(surahNumber);

  /// Surahs not yet recited this cycle, in surah-number order.
  /// (Filtering the already-sorted [_memorized] preserves the order — no sort.)
  List<int> get dueNext =>
      _memorized.where((n) => !_recited.contains(n)).toList();

  /// Surahs already recited this cycle, in surah-number order.
  List<int> get recitedThisCycle =>
      _memorized.where((n) => _recited.contains(n)).toList();

  Future<void> addMemorized(int surahNumber) async {
    _memorized.add(surahNumber);
    await _save();
  }

  Future<void> removeMemorized(int surahNumber) async {
    _memorized.remove(surahNumber);
    _recited.remove(surahNumber);
    await _save();
  }

  /// Marks/unmarks a surah as recited in the current cycle.
  ///
  /// Returns true if this action completed the full cycle (all memorized surahs recited)
  Future<bool> toggleRecited(int surahNumber) async {
    if (!_memorized.contains(surahNumber)) return false;

    var cycleCompleted = false;
    if (_recited.contains(surahNumber)) {
      _recited.remove(surahNumber);
    } else {
      _recited.add(surahNumber);
      if (_recited.length == _memorized.length && _memorized.isNotEmpty) {
        // Whole cycle done -> Start over
        _recited.clear();
        cycleCompleted = true;
      }
    }
    await _save();
    return cycleCompleted;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _memorizedKey,
      _memorized.map((n) => n.toString()).toList(),
    );
    await prefs.setStringList(
      _recitedKey,
      _recited.map((n) => n.toString()).toList(),
    );
  }
}
