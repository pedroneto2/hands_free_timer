package com.hands_free_timer.app

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val handler = Handler(Looper.getMainLooper())
    private val dimRunnable = Runnable { setBrightness(0.01f) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        scheduleDim()
    }

    override fun onUserInteraction() {
        super.onUserInteraction()
        setBrightness(WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE)
        scheduleDim()
    }

    private fun scheduleDim() {
        handler.removeCallbacks(dimRunnable)
        handler.postDelayed(dimRunnable, 30_000L)
    }

    private fun setBrightness(value: Float) {
        val attrs = window.attributes
        attrs.screenBrightness = value
        window.attributes = attrs
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        AudioStreamChannel(
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "hands_free_timer/audio_stream"),
            applicationContext,
        )
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        super.onDestroy()
    }
}
