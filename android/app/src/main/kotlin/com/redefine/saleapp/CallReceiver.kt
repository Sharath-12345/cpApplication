package com.redefine.saleapp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi

class CallReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context?, intent: Intent?) {
        val phoneNumber = intent?.getStringExtra("phoneNumber")
        // val phoneNumber="9999999999"
        if (!phoneNumber.isNullOrEmpty()) {
            Log.d("CallReceiver", "Received phone number: $phoneNumber")

            val serviceIntent = Intent(context, CallService::class.java)
            serviceIntent.putExtra("phoneNumber", phoneNumber)

            context?.startForegroundService(serviceIntent)
        }
    }
}
