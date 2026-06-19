import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Corner radius shared by surah cards and the primary "Edit list" button.
const double kCardRadius = 16;

/// The "Tahajjud" palette (Direction C) in light and dark tonal modes.
/// Custom widgets read these via [AppPalette.of]; standard Material widgets
/// use the [ColorScheme] built in [buildAppTheme].
class AppPalette {
  final Color background; // scaffold base
  final Color backgroundTop; // top tint of the background gradient
  final Color surface; // card fill
  final Color cardBorder;

  final Color brand; // header title
  final Color tagline;
  final Color ornament; // header flourish + accents
  final Color sectionDue; // "DUE NEXT" label
  final Color sectionDone; // "RECITED THIS CYCLE" label

  final Color badgeBg;
  final Color badgeFg;
  final Color badgeBorder;
  final Color name;
  final Color ayahs;
  final Color reciteBg;
  final Color reciteFg;
  final Color status; // recited check / empty ring

  final Color recitedTile;
  final Color recitedName;
  final Color recitedBadgeBg;
  final Color recitedBadgeFg;
  final Color recitedReciteBg;
  final Color recitedReciteFg;

  final Color fabStart;
  final Color fabEnd;
  final Color onFab;

  const AppPalette({
    required this.background,
    required this.backgroundTop,
    required this.surface,
    required this.cardBorder,
    required this.brand,
    required this.tagline,
    required this.ornament,
    required this.sectionDue,
    required this.sectionDone,
    required this.badgeBg,
    required this.badgeFg,
    required this.badgeBorder,
    required this.name,
    required this.ayahs,
    required this.reciteBg,
    required this.reciteFg,
    required this.status,
    required this.recitedTile,
    required this.recitedName,
    required this.recitedBadgeBg,
    required this.recitedBadgeFg,
    required this.recitedReciteBg,
    required this.recitedReciteFg,
    required this.fabStart,
    required this.fabEnd,
    required this.onFab,
  });

  static const dark = AppPalette(
    background: Color(0xFF0C1C1B),
    backgroundTop: Color(0xFF143230),
    surface: Color(0x0AFFFFFF),
    cardBorder: Color(0x29CBA35A),
    brand: Color(0xFFF0EAD9),
    tagline: Color(0xFF7FA093),
    ornament: Color(0xFFCBA35A),
    sectionDue: Color(0xFFCBA35A),
    sectionDone: Color(0xFF5F726B),
    badgeBg: Color(0x1FCBA35A),
    badgeFg: Color(0xFFE3C585),
    badgeBorder: Color(0x66CBA35A),
    name: Color(0xFFEEF1EC),
    ayahs: Color(0xFF7E928A),
    reciteBg: Color(0x24CBA35A),
    reciteFg: Color(0xFFE3C585),
    status: Color(0xFFCBA35A),
    recitedTile: Color(0x05FFFFFF),
    recitedName: Color(0xFF8A9089),
    recitedBadgeBg: Color(0x0DFFFFFF),
    recitedBadgeFg: Color(0xFF8A9089),
    recitedReciteBg: Color(0x0AFFFFFF),
    recitedReciteFg: Color(0xFF6F7D76),
    fabStart: Color(0xFFD9B266),
    fabEnd: Color(0xFFC79A45),
    onFab: Color(0xFF20180A),
  );

  static const light = AppPalette(
    background: Color(0xFFF6F1E6),
    backgroundTop: Color(0xFFE9EFE7),
    surface: Color(0xFFFFFDF8),
    cardBorder: Color(0xFFECE4D2),
    brand: Color(0xFF163230),
    tagline: Color(0xFF6C8A7D),
    ornament: Color(0xFFAB8038),
    sectionDue: Color(0xFF9C7430),
    sectionDone: Color(0xFFB3AB97),
    badgeBg: Color(0xFF163230),
    badgeFg: Color(0xFFF0EAD9),
    badgeBorder: Color(0x8CAB8038),
    name: Color(0xFF1D2B27),
    ayahs: Color(0xFF8C8674),
    reciteBg: Color(0xFFEEF3EE),
    reciteFg: Color(0xFF1C5A4A),
    status: Color(0xFFAB8038),
    recitedTile: Color(0xFFF2ECE0),
    recitedName: Color(0xFF7C7565),
    recitedBadgeBg: Color(0xFFD9D0BC),
    recitedBadgeFg: Color(0xFFFFFFFF),
    recitedReciteBg: Color(0xFFE9E2D3),
    recitedReciteFg: Color(0xFFAA9F88),
    fabStart: Color(0xFFD9B266),
    fabEnd: Color(0xFFC79A45),
    onFab: Color(0xFF20180A),
  );

  /// The rounded, bordered shape used for surah cards.
  ShapeBorder get cardShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        side: BorderSide(color: cardBorder),
      );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

ThemeData buildAppTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
  final base = ThemeData(brightness: brightness, useMaterial3: true);

  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C5A4A),
        brightness: brightness,
      ).copyWith(
        surface: p.background,
        primary: brightness == Brightness.dark
            ? const Color(0xFFCBA35A)
            : const Color(0xFF163230),
        secondary: const Color(0xFFCBA35A),
      );

  // Centralized typography. Cormorant Garamond for display/headline/badge
  // numbers; Spline Sans for everything else. Colours are baked in per role,
  // so components reference named styles instead of re-declaring fonts.
  //   displaySmall  -> app brand title
  //   headlineSmall -> empty-state heading
  //   titleLarge    -> surah number badge (Cormorant)
  //   titleMedium   -> surah name
  //   bodySmall     -> ayah count / supporting text
  //   labelMedium   -> section headers (DUE NEXT)
  //   labelLarge    -> button labels (FAB)
  final textTheme = GoogleFonts.splineSansTextTheme(base.textTheme)
      .apply(bodyColor: p.name, displayColor: p.name)
      .copyWith(
        displaySmall: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: p.brand,
          height: 1.0,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: p.brand,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: p.badgeFg,
          height: 1.0,
          fontFeatures: const [
            FontFeature.liningFigures(),
            FontFeature.tabularFigures(),
          ],
        ),
        titleMedium: GoogleFonts.splineSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: p.name,
        ),
        bodySmall: GoogleFonts.splineSans(fontSize: 12.5, color: p.ayahs),
        labelLarge: GoogleFonts.splineSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: p.name,
        ),
        labelMedium: GoogleFonts.splineSans(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color: p.sectionDue,
        ),
      );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.cormorantGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: p.brand,
      ),
      iconTheme: IconThemeData(color: p.name),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
