package com.saadsymoom.tilawah_tracker

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "refresh") {
                    sendBroadcast(
                        Intent(this, TilawahWidgetProvider::class.java)
                            .setAction(TilawahWidgetProvider.ACTION_REFRESH)
                    )
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    companion object {
        private const val CHANNEL = "tilawah/widget"
    }
}
