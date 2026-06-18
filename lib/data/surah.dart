import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// One chapter of the Qur'an. This is static reference data (it never changes),
/// loaded from assets/surahs.json. User data like "when did I last recite this"
/// will live separately in a database later.
class Surah {
  final int number;
  final String name;
  final int ayahCount;

  const Surah({
    required this.number,
    required this.name,
    required this.ayahCount,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      ayahCount: json['ayahCount'] as int,
    );
  }
}

/// Reads the 114 surahs bundled in assets/surahs.json and turns them into
/// a list of [Surah] objects. Async because reading a bundled asset is an
/// I/O operation.
Future<List<Surah>> loadSurahs() async {
  final raw = await rootBundle.loadString('assets/surahs.json');
  final List<dynamic> data = json.decode(raw) as List<dynamic>;
  return data
      .map((item) => Surah.fromJson(item as Map<String, dynamic>))
      .toList();
}
