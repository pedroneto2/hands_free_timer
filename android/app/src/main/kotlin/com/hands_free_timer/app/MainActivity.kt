package com.hands_free_timer.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())

    companion object {
        private const val CHANNEL_ID = "timer_wake_channel"
        private const val NOTIFICATION_ID = 1001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyLockScreenFlags()
        createNotificationChannel()
    }

    // Called once at startup and refreshed on every wakeScreen() call.
    private fun applyLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
        @Suppress("DEPRECATION")
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
        )
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Timer Alerts",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        AudioStreamChannel(
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "hands_free_timer/audio_stream"),
            applicationContext,
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hands_free_timer/wake_screen")
            .setMethodCallHandler { call, result ->
                if (call.method == "wakeScreen") {
                    wakeScreen()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun wakeScreen() {
        applyLockScreenFlags()

        // On Android 10+ (API 29+), ACQUIRE_CAUSES_WAKEUP is silently ignored
        // for background apps. A full-screen intent notification is the only
        // supported mechanism to wake the screen from the background.
        showWakeNotification()

        // Keep the wake lock as an additional guarantee for older devices.
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock?.release()
        @Suppress("DEPRECATION")
        wakeLock = pm.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or
            PowerManager.ACQUIRE_CAUSES_WAKEUP or
            PowerManager.ON_AFTER_RELEASE,
            "hands_free_timer::wake",
        )
        wakeLock!!.acquire(10_000L)
    }

    private fun showWakeNotification() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val piFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        else
            PendingIntent.FLAG_UPDATE_CURRENT
        val pi = PendingIntent.getActivity(this, 0, intent, piFlags)

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this).setPriority(Notification.PRIORITY_MAX)
        }

        val notification = builder
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle("Hands Free Timer")
            .setContentText("Timer alert!")
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setFullScreenIntent(pi, true)
            .setAutoCancel(true)
            .build()

        nm.notify(NOTIFICATION_ID, notification)

        // Auto-dismiss after 10 s so it doesn't linger in the shade.
        handler.postDelayed({ nm.cancel(NOTIFICATION_ID) }, 10_000L)
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        wakeLock?.release()
        super.onDestroy()
    }
}
