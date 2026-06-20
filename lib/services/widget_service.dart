import 'package:flutter/services.dart';

/// Triggers a redraw of the native home-screen widget.
///
/// The widget reads the rotation state itself (the same store the app writes),
/// so there's no data to push here — we just tell it to re-render. This goes
/// through a tiny platform channel (not `home_widget`'s `updateWidget`) because
/// that one refreshes via an ACTION_APPWIDGET_UPDATE broadcast, which Android
/// echoes into a duplicate update and makes the widget flicker.
class WidgetService {
  static const _channel = MethodChannel('tilawah/widget');

  static Future<void> refresh() async {
    try {
      await _channel.invokeMethod<void>('refresh');
    } on PlatformException {
      // Widget unsupported or not placed — nothing to refresh.
    } on MissingPluginException {
      // No native handler (e.g. in tests).
    }
  }
}
