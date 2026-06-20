package com.saadsymoom.tilawah_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * Home-screen widget showing the next surahs due in the rotation.
 *
 * The widget reads and writes the SAME rotation state the app uses
 * (`flutter.memorized` / `flutter.recited_this_cycle` in FlutterSharedPreferences)
 */
class TilawahWidgetProvider : HomeWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_MARK -> {
                val surah = intent.getIntExtra(EXTRA_SURAH, -1)
                if (surah > 0) {
                    toggleRecited(context, surah)
                    render(context)
                }
            }
            ACTION_REFRESH -> render(context)
            else -> super.onReceive(context, intent) // APPWIDGET_UPDATE -> onUpdate
        }
    }

    // System-driven update (first placement, reboot, re-add). Render from store.
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        render(context, appWidgetManager, appWidgetIds)
    }

    /** Renders every placed instance of this widget. */
    private fun render(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            ComponentName(context, TilawahWidgetProvider::class.java)
        )
        render(context, manager, ids)
    }

    private fun render(
        context: Context,
        manager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val due = dueNext(context)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.tilawah_widget)
            views.setOnClickPendingIntent(
                R.id.widget_plus, launchIntent(context, "edit", REQ_EDIT)
            )
            views.setViewVisibility(
                R.id.widget_empty,
                if (due.isEmpty()) View.VISIBLE else View.GONE
            )

            // Rebuild the rows from the due list (one widget_row each, with a
            // divider between). Done once per change, so it does not flicker.
            views.removeAllViews(R.id.rows_container)
            due.forEachIndexed { i, number ->
                if (i > 0) {
                    views.addView(
                        R.id.rows_container,
                        RemoteViews(context.packageName, R.layout.widget_divider)
                    )
                }
                val row = RemoteViews(context.packageName, R.layout.widget_row)
                row.setTextViewText(R.id.badge, number.toString())
                row.setTextViewText(R.id.name, surahName(context, number))
                row.setOnClickPendingIntent(R.id.row_root, launchIntent(context, "home", REQ_HOME))
                row.setOnClickPendingIntent(R.id.tarteel, tarteelIntent(context, number))
                row.setOnClickPendingIntent(R.id.mark, markIntent(context, number))
                views.addView(R.id.rows_container, row)
            }

            manager.updateAppWidget(widgetId, views)
        }
    }

    // --- Rotation state (mirrors lib/data/memorized_store.dart) -------------

    private fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    /** Reads a comma-joined number set written by the app via `setString`. */
    private fun readSet(context: Context, key: String): MutableSet<Int> {
        val raw = prefs(context).getString("flutter.$key", "") ?: ""
        return raw.split(",").mapNotNull { it.trim().toIntOrNull() }.toMutableSet()
    }

    /** The next surahs due (sorted memorized minus recited), capped at MAX_ROWS. */
    private fun dueNext(context: Context): List<Int> {
        val recited = readSet(context, KEY_RECITED)
        return readSet(context, KEY_MEMORIZED)
            .sorted()
            .filter { it !in recited }
            .take(MAX_ROWS)
    }

    /** Toggles a surah in the recited set; clears the cycle when all are done. */
    private fun toggleRecited(context: Context, surah: Int) {
        val memorized = readSet(context, KEY_MEMORIZED)
        if (surah !in memorized) return

        val recited = readSet(context, KEY_RECITED)
        if (!recited.remove(surah)) {
            recited.add(surah)
            if (recited.size == memorized.size) recited.clear() // full cycle -> restart
        }
        prefs(context).edit()
            .putString("flutter.$KEY_RECITED", recited.joinToString(","))
            .apply()
    }

    // --- Surah names from the bundled Flutter asset -------------------------

    private fun surahName(context: Context, number: Int): String =
        names(context)[number] ?: "Surah $number"

    private fun names(context: Context): Map<Int, String> {
        nameCache?.let { return it }
        val map = HashMap<Int, String>()
        try {
            val raw = context.assets.open("flutter_assets/assets/surahs.json")
                .bufferedReader()
                .use { it.readText() }
            val arr = JSONArray(raw)
            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                map[obj.getInt("number")] = obj.getString("name")
            }
        } catch (e: Exception) {
            android.util.Log.e("TilawahWidget", "Failed to read surahs.json", e)
        }
        nameCache = map
        return map
    }

    // --- Intents ------------------------------------------------------------

    /** Opens the app at [host] — a deep link the Dart side routes on. */
    private fun launchIntent(context: Context, host: String, requestCode: Int): PendingIntent {
        val intent = Intent(context, MainActivity::class.java)
            .setAction(HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION)
            .setData(Uri.parse("$SCHEME://$host"))
        return PendingIntent.getActivity(
            context, requestCode, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    /** Opens the surah in Tarteel (verified App Link → app, else browser). */
    private fun tarteelIntent(context: Context, surah: Int): PendingIntent {
        val intent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("https://tarteel.ai/ayah/$surah/1")
        )
        return PendingIntent.getActivity(
            context, TARTEEL_REQUEST_BASE + surah, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    /** Marks the surah recited natively (a broadcast back to this provider). */
    private fun markIntent(context: Context, surah: Int): PendingIntent {
        val intent = Intent(context, TilawahWidgetProvider::class.java)
            .setAction(ACTION_MARK)
            .putExtra(EXTRA_SURAH, surah)
        return PendingIntent.getBroadcast(
            context, MARK_REQUEST_BASE + surah, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    companion object {
        const val ACTION_REFRESH = "com.saadsymoom.tilawah_tracker.WIDGET_REFRESH"

        private const val ACTION_MARK = "com.saadsymoom.tilawah_tracker.WIDGET_MARK"
        private const val EXTRA_SURAH = "surah"

        private const val KEY_MEMORIZED = "memorized"
        private const val KEY_RECITED = "recited_this_cycle"

        private const val MAX_ROWS = 4
        private const val SCHEME = "tilawahtracker"

        // Distinct request codes so PendingIntents never collide
        private const val REQ_EDIT = 1
        private const val REQ_HOME = 2
        private const val TARTEEL_REQUEST_BASE = 1000
        private const val MARK_REQUEST_BASE = 2000

        @Volatile
        private var nameCache: Map<Int, String>? = null
    }
}
