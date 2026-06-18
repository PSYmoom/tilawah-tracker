import 'surah.dart';

/// Holds the static list of all 114 surahs (loaded once from the bundled JSON)
class SurahCatalog {
  List<Surah> _all = [];

  Future<void> load() async {
    _all = await loadSurahs();
  }

  List<Surah> get all => _all;

  /// O(1) lookup by surah number
  Surah? getSurah(int n) => (n >= 1 && n <= _all.length) ? _all[n - 1] : null;
}
