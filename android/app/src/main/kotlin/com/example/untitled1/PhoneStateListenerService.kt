package com.example.untitled1

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.util.Log
import androidx.core.app.NotificationCompat

class PhoneStateListenerService : Service() {
    companion object {
        private const val TAG = "PhoneStateListenerSvc"
        private const val NOTIFICATION_ID = 3
        private const val CHANNEL_ID = "phone_state_listener_channel"
    }

    private var telephonyManager: TelephonyManager? = null
    private var phoneStateListener: PhoneStateListener? = null
    private var lastCallState = TelephonyManager.CALL_STATE_IDLE
    private var lastPhoneNumber: String? = null

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "PhoneStateListenerService onCreate")
        createNotificationChannel()
        setupPhoneStateListener()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "PhoneStateListenerService onStartCommand - flags: $flags, startId: $startId")

        try {
            // Start as foreground service
            val notification = createNotification()
            startForeground(NOTIFICATION_ID, notification)
            Log.d(TAG, "Foreground service started with notification")

            // Register the phone state listener
            registerPhoneStateListener()

            Log.d(TAG, "PhoneStateListenerService is now running persistently")
        } catch (e: Exception) {
            Log.e(TAG, "Error in onStartCommand: ${e.message}")
            e.printStackTrace()
        }

        // Return START_STICKY to restart if killed by system
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Phone State Monitoring",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Monitors phone state for call detection"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        // Create intent to open the app when notification is tapped
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("iCRM Always Running")
            .setContentText("Call detection active - Tap to open app")
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(pendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // For Android 12+, set the foreground service type
            builder.setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
        }

        return builder.build()
    }

    private fun setupPhoneStateListener() {
        telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        phoneStateListener = object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, phoneNumber: String?) {
                super.onCallStateChanged(state, phoneNumber)
                handleCallStateChange(state, phoneNumber)
            }
        }
    }

    private fun registerPhoneStateListener() {
        try {
            telephonyManager?.listen(phoneStateListener, PhoneStateListener.LISTEN_CALL_STATE)
            Log.d(TAG, "Phone state listener registered successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error registering phone state listener: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun handleCallStateChange(state: Int, phoneNumber: String?) {
        Log.d(TAG, "=== Phone State Changed ===")
        Log.d(TAG, "State: ${getStateString(state)}")
        Log.d(TAG, "Phone Number: $phoneNumber")
        Log.d(TAG, "Last State: ${getStateString(lastCallState)}")
        Log.d(TAG, "Last Phone Number: $lastPhoneNumber")

        when (state) {
            TelephonyManager.CALL_STATE_RINGING -> {
                Log.d(TAG, "Incoming call detected")
                lastPhoneNumber = phoneNumber
            }
            TelephonyManager.CALL_STATE_OFFHOOK -> {
                Log.d(TAG, "Call answered/outgoing call")
                if (lastPhoneNumber == null) {
                    lastPhoneNumber = phoneNumber
                }
            }
            TelephonyManager.CALL_STATE_IDLE -> {
                if (lastCallState != TelephonyManager.CALL_STATE_IDLE) {
                    Log.d(TAG, "Call ended - processing")
                    val numberToProcess = lastPhoneNumber ?: phoneNumber
                    if (numberToProcess != null) {
                        processCallEnd(numberToProcess)
                    } else {
                        Log.w(TAG, "No phone number available for call end processing")
                    }
                }
                lastPhoneNumber = null
            }
        }

        lastCallState = state
        Log.d(TAG, "=== Phone State Change Processed ===")
    }

    private fun processCallEnd(phoneNumber: String) {
        Log.d(TAG, "Processing call end for number: $phoneNumber")

        try {
            // Start the background service to handle the call
            val serviceIntent = Intent(this, CallDetectionBackgroundService::class.java).apply {
                putExtra("phoneNumber", phoneNumber)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
                Log.d(TAG, "Started foreground background service for call processing")
            } else {
                startService(serviceIntent)
                Log.d(TAG, "Started background service for call processing")
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error starting background service for call processing: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun getStateString(state: Int): String {
        return when (state) {
            TelephonyManager.CALL_STATE_IDLE -> "IDLE"
            TelephonyManager.CALL_STATE_RINGING -> "RINGING"
            TelephonyManager.CALL_STATE_OFFHOOK -> "OFFHOOK"
            else -> "UNKNOWN($state)"
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "PhoneStateListenerService onDestroy - Service is being destroyed")

        try {
            // Unregister phone state listener
            telephonyManager?.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE)
            Log.d(TAG, "Phone state listener unregistered")
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering phone state listener: ${e.message}")
        }

        // Try to restart the service if it's being killed unexpectedly
        try {
            Log.d(TAG, "Attempting to restart service...")
            val restartIntent = Intent(this, PhoneStateListenerService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(restartIntent)
            } else {
                startService(restartIntent)
            }
            Log.d(TAG, "Service restart initiated")
        } catch (e: Exception) {
            Log.e(TAG, "Error restarting service: ${e.message}")
        }

        super.onDestroy()
    }
}
