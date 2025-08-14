package com.redefine.saleapp


import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        val data = remoteMessage.data
        val phoneNumber = data["phoneNumber"]
     //   val phoneNumber="9999999999";

        if (!phoneNumber.isNullOrEmpty()) {
            Log.d("FCM", "Phone number received from FCM: $phoneNumber")
            print("\"FCM\", \"Phone number received from FCM: $phoneNumber")

            val broadcastIntent = Intent(this, CallReceiver::class.java)
            broadcastIntent.putExtra("phoneNumber", phoneNumber)

            sendBroadcast(broadcastIntent)
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "New token: $token")
    }
}
