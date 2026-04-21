package com.hands_free_timer.app

import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import io.flutter.plugin.common.EventChannel

class AudioStreamChannel(
    channel: EventChannel,
    private val context: Context,
) : EventChannel.StreamHandler {
    private var audioRecord: AudioRecord? = null
    private var recordingThread: Thread? = null
    private var isRecording = false
    private val mainHandler = Handler(Looper.getMainLooper())
    private var cpuWakeLock: PowerManager.WakeLock? = null

    init {
        channel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // Keep CPU alive while screen is off so audio detection keeps running.
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        @Suppress("WakelockTimeout")
        cpuWakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "hands_free_timer::audio_detect",
        ).also { it.acquire() }

        val sampleRate = 16000
        val minBuffer = AudioRecord.getMinBufferSize(
            sampleRate,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
        )
        val bufferSize = maxOf(minBuffer * 2, 4096)

        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            sampleRate,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize,
        )

        if (audioRecord!!.state != AudioRecord.STATE_INITIALIZED) {
            cpuWakeLock?.release()
            cpuWakeLock = null
            events?.error("AUDIO_INIT_FAILED", "AudioRecord could not be initialized", null)
            return
        }

        isRecording = true
        audioRecord!!.startRecording()

        recordingThread = Thread {
            val buffer = ByteArray(bufferSize / 2)
            while (isRecording) {
                val read = audioRecord!!.read(buffer, 0, buffer.size)
                if (read > 0) {
                    val chunk = buffer.copyOf(read)
                    mainHandler.post { events?.success(chunk) }
                }
            }
        }.also { it.start() }
    }

    override fun onCancel(arguments: Any?) {
        isRecording = false
        recordingThread?.join(1000)
        recordingThread = null
        if (audioRecord?.state == AudioRecord.STATE_INITIALIZED) {
            audioRecord?.stop()
        }
        audioRecord?.release()
        audioRecord = null
        cpuWakeLock?.release()
        cpuWakeLock = null
    }
}
