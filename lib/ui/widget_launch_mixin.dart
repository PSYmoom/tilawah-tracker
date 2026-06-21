import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../services/widget_service.dart';

/// Bundles the app↔home-screen-widget plumbing for a screen's [State]:
///  - routes the widget's launch URIs (the "+" / row taps) to the screen,
///  - reloads the screen when the app returns to the foreground (the widget
///    shares the rotation store and may have changed it),
///  - exposes [syncWidget] to tell the widget to re-render after app changes.
///
/// The screen supplies the three hooks below; this mixin owns the subscription,
/// the lifecycle listener, and the navigation timing.
mixin WidgetLaunchMixin<W extends StatefulWidget> on State<W> {
  StreamSubscription<Uri?>? _widgetClickSub;
  late final AppLifecycleListener _lifecycle;

  /// Completes once the screen's initial data load is done; navigation from a
  /// widget launch waits on this so the screen is ready.
  Future<void> get launchReady;

  /// Called when the app returns to the foreground (reload shared state).
  Future<void> onAppResumed();

  /// Called with the launch URI's host ("edit" / "home"), so the screen can navigate.
  void onWidgetLaunch(String host);

  void initWidgetLaunch() {
    _widgetClickSub = HomeWidget.widgetClicked.listen(_handleUri);
    _lifecycle = AppLifecycleListener(onResume: onAppResumed);
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleUri);
  }

  void disposeWidgetLaunch() {
    _widgetClickSub?.cancel();
    _lifecycle.dispose();
  }

  /// Tells the native widget to re-render (it reads the shared store itself).
  void syncWidget() => WidgetService.refresh();

  void _handleUri(Uri? uri) {
    final host = uri?.host;
    if (host == null) return;
    launchReady.then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) onWidgetLaunch(host);
      });
    });
  }
}
