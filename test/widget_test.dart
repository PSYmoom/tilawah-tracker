// Basic smoke test: the app builds, loads, and shows the empty state when no
// surahs are memorized yet.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tilawah_tracker/main.dart';

void main() {
  testWidgets('App builds and shows the empty state', (tester) async {
    // No saved data -> the memorized list is empty.
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const TilawahApp());
    await tester.pumpAndSettle(); // let loading finish

    expect(find.text('TilawahTracker'), findsOneWidget);
    expect(find.text('No memorized surahs yet'), findsOneWidget);
  });
}
