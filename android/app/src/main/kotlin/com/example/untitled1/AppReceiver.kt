package com.example.untitled1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * This is a placeholder receiver to prevent crashes.
 * The actual call detection is handled by CallStateReceiver.
 */
class AppReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "AppReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Received intent: ${intent.action}")
        // This is just a placeholder to prevent crashes
        // The actual call detection is handled by CallStateReceiver
    }
} 