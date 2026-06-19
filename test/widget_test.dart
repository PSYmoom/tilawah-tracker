// Basic smoke test: the app builds, loads, and shows the empty state when no
// surahs are memorized yet.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tilawah_tracker/main.dart';

void main() {
  testWidgets('App builds and shows the empty state', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false; // no network in tests
    SharedPreferences.setMockInitialValues({}); // no saved data

    await tester.pumpWidget(const TilawahApp());
    await tester.pumpAndSettle();

    expect(find.text('No memorized surahs yet'), findsOneWidget);
  });
}
