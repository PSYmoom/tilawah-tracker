// Basic smoke test: the app builds and shows its title.

import 'package:flutter_test/flutter_test.dart';

import 'package:tilawah_tracker/main.dart';

void main() {
  testWidgets('App builds and shows the title', (WidgetTester tester) async {
    await tester.pumpWidget(const TilawahApp());

    // The AppBar title renders immediately (before the surah list finishes
    // loading), so we can assert on it without waiting for async work.
    expect(find.text('TilawahTracker'), findsOneWidget);
  });
}
