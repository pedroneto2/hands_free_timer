package com.hands_free_timer.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AudioStreamChannel(
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "hands_free_timer/audio_stream")
        )
    }
}
