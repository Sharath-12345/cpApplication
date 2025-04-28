package com.redefine.saleapp


import io.flutter.embedding.android.FlutterActivity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.content.Context
import androidx.core.net.toUri

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "your_channel_id" // 👈 same as payload
            val channelName = "Call Notifications"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val soundUri = ("android.resource://" + packageName + "/raw/call_sound").toUri()

            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            val channel = NotificationChannel(channelId, channelName, importance)
            channel.description = "Channel for call notifications"
            channel.setSound(soundUri, audioAttributes)

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}

