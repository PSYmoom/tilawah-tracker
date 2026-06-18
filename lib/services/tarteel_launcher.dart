import 'package:url_launcher/url_launcher.dart';

/// Encapsulates opening a surah in Tarteel
class TarteelLauncher {
  /// Opens the given surah in Tarteel
  /// If app is not installed, falls back to the Tarteel website
  Future<bool> openSurah(int surahNumber) => launchUrl(
        Uri.parse('https://tarteel.ai/ayah/$surahNumber/1'),
        mode: LaunchMode.externalApplication,
      );
}
