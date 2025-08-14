package com.redefine.saleapp



import android.app.*
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class CallService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
      val phoneNumber = intent?.getStringExtra("phoneNumber")
        // val phoneNumber="9999999999"
        if (!phoneNumber.isNullOrEmpty()) {
            // Step 1: Start foreground notification
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channelId = "call_channel"
                val channel = NotificationChannel(
                    channelId,
                    "Call Channel",
                    NotificationManager.IMPORTANCE_LOW
                )

                val manager = getSystemService(NotificationManager::class.java)
                manager?.createNotificationChannel(channel)

                val notification: Notification = NotificationCompat.Builder(this, channelId)
                    .setContentTitle("Calling $phoneNumber")
                    .setSmallIcon(android.R.drawable.ic_menu_call)
                    .build()

                startForeground(1, notification)
            }

            // Step 2: Make the call
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE)
                == PackageManager.PERMISSION_GRANTED
            ) {
                val callIntent = Intent(Intent.ACTION_CALL)
                callIntent.data = Uri.parse("tel:$phoneNumber")
                callIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                startActivity(callIntent)
            }
        }

        // Step 3: Stop service once done
        stopSelf()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
