package com.example.untitled1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "BootReceiver triggered: ${intent.action}")

        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_PACKAGE_REPLACED -> {
                Log.d(TAG, "System boot completed or package replaced - Starting phone state listener service")

                try {
                    // Start the phone state listener service automatically
                    val serviceIntent = Intent(context, PhoneStateListenerService::class.java)

                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        context.startForegroundService(serviceIntent)
                        Log.d(TAG, "Started foreground phone state listener service on boot")
                    } else {
                        context.startService(serviceIntent)
                        Log.d(TAG, "Started phone state listener service on boot")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting phone state listener service on boot: ${e.message}")
                    e.printStackTrace()
                }
            }
        }
    }
}
