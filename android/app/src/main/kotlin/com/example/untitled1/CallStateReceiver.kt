package com.example.untitled1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.Log
import android.widget.Toast
import android.os.PowerManager
import android.content.ComponentName

class CallStateReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "CallStateReceiver"
        var lastState = TelephonyManager.CALL_STATE_IDLE
        var lastPhoneNumber: String? = null
        var callEndListener: ((String) -> Unit)? = null
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "=== CallStateReceiver.onReceive TRIGGERED ===")
        Log.d(TAG, "Action: ${intent.action}")
        Log.d(TAG, "Package: ${context.packageName}")
        Log.d(TAG, "Process: ${android.os.Process.myPid()}")

        // Acquire wake lock to ensure processing completes even if device is sleeping
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "CallStateReceiver::onReceive"
        )

        try {
            wakeLock.acquire(10000) // Hold wake lock for up to 10 seconds
            Log.d(TAG, "Wake lock acquired")

            // Handle different intent actions
            when (intent.action) {
                TelephonyManager.ACTION_PHONE_STATE_CHANGED -> {
                    Log.d(TAG, "Handling PHONE_STATE_CHANGED")
                    handlePhoneStateChanged(intent, context)
                }
                Intent.ACTION_NEW_OUTGOING_CALL -> {
                    Log.d(TAG, "Handling NEW_OUTGOING_CALL")
                    handleOutgoingCall(intent)
                }
                else -> {
                    Log.w(TAG, "Ignoring unknown action: ${intent.action}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onReceive: ${e.message}")
            e.printStackTrace()
        } finally {
            if (wakeLock.isHeld) {
                wakeLock.release()
                Log.d(TAG, "Wake lock released")
            }
        }
        Log.d(TAG, "=== CallStateReceiver.onReceive COMPLETED ===")
    }

    private fun handlePhoneStateChanged(intent: Intent, context: Context) {
        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
        val phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER) ?: ""

        Log.d(TAG, "Phone state changed: $state, number: ${if (phoneNumber.isNotEmpty()) phoneNumber else "unknown"}")

        when (state) {
            TelephonyManager.EXTRA_STATE_IDLE -> {
                // Call ended
                Log.d(TAG, "Call state: IDLE")
                if (lastState == TelephonyManager.CALL_STATE_OFFHOOK) {
                    // This was a call that ended
                    Log.d(TAG, "Call ended with number: $lastPhoneNumber")

                    // If we don't have a phone number, use a default for testing
                    val numberToUse = if (lastPhoneNumber.isNullOrEmpty()) {
                        "01645467222" // Default test number
                    } else {
                        lastPhoneNumber!!
                    }

                    // Normalize the phone number to handle country codes
                    val normalizedNumber = normalizePhoneNumber(numberToUse)
                    Log.d(TAG, "Normalized number for notification: $normalizedNumber (original: $numberToUse)")

                    Log.d(TAG, "Processing call end with number: $normalizedNumber")

                    // Always start background service to handle call detection
                    // This ensures it works whether app is running, background, or killed
                    startBackgroundService(context, normalizedNumber)

                    // Also try to notify Flutter if available (for when app is running)
                    try {
                        callEndListener?.invoke(normalizedNumber)
                        Log.d(TAG, "Successfully notified Flutter about call end")
                    } catch (e: Exception) {
                        Log.d(TAG, "Flutter not available or error notifying: ${e.message}")
                        // This is expected when app is in background/killed
                    }
                }
                lastState = TelephonyManager.CALL_STATE_IDLE
            }
            TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                // Call started
                Log.d(TAG, "Call state: OFFHOOK")
                lastState = TelephonyManager.CALL_STATE_OFFHOOK
                if (phoneNumber.isNotEmpty()) {
                    Log.d(TAG, "Saving phone number: $phoneNumber")
                    lastPhoneNumber = phoneNumber
                }
            }
            TelephonyManager.EXTRA_STATE_RINGING -> {
                // Phone is ringing
                Log.d(TAG, "Call state: RINGING")
                lastState = TelephonyManager.CALL_STATE_RINGING
                if (phoneNumber.isNotEmpty()) {
                    Log.d(TAG, "Saving phone number: $phoneNumber")
                    lastPhoneNumber = phoneNumber
                }
            }
            else -> {
                Log.d(TAG, "Unknown call state: $state")
            }
        }
    }

    private fun handleOutgoingCall(intent: Intent) {
        val phoneNumber = intent.getStringExtra(Intent.EXTRA_PHONE_NUMBER)
        if (phoneNumber != null && phoneNumber.isNotEmpty()) {
            // Normalize the outgoing call number
            val normalizedNumber = normalizePhoneNumber(phoneNumber)
            Log.d(TAG, "Outgoing call to: $normalizedNumber (original: $phoneNumber)")
            lastPhoneNumber = normalizedNumber
        } else {
            Log.d(TAG, "Outgoing call with unknown number")
        }
    }

    private fun showOverlay(context: Context, phoneNumber: String) {
        // Check if we have the overlay permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            Log.e(TAG, "Cannot show overlay - permission not granted")
            Toast.makeText(context, "Cannot show overlay - permission not granted", Toast.LENGTH_LONG).show()
            return
        }

        try {
            // Start the overlay service
            val intent = Intent(context, OverlayService::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                putExtra("phoneNumber", phoneNumber)
                putExtra("leadName", "Call from $phoneNumber")
            }

            Log.d(TAG, "Starting overlay service with number: $phoneNumber")

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // For Android 12+ (API 31+), we need to specify the foreground service type
                    intent.putExtra("foregroundServiceType", 1) // 1 = FOREGROUND_SERVICE_TYPE_PHONE_CALL
                    context.startForegroundService(intent)
                    Log.d(TAG, "Started foreground service with type PHONE_CALL (Android 12+)")
                } else {
                    // For Android 8-11
                    context.startForegroundService(intent)
                    Log.d(TAG, "Started foreground service (Android 8-11)")
                }
            } else {
                // For Android 7 and below
                context.startService(intent)
                Log.d(TAG, "Started regular service (Android 7 and below)")
            }

            Log.d(TAG, "Started overlay service")
        } catch (e: Exception) {
            Log.e(TAG, "Error starting overlay service: ${e.message}")
            e.printStackTrace()
            Toast.makeText(context, "Error showing popup: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    // Start background service when Flutter is not available
    private fun startBackgroundService(context: Context, phoneNumber: String) {
        Log.d(TAG, "Starting background service for call detection")

        try {
            // Start a background service that will handle the call detection
            val serviceIntent = Intent(context, CallDetectionBackgroundService::class.java).apply {
                putExtra("phoneNumber", phoneNumber)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
                Log.d(TAG, "Started foreground background service")
            } else {
                context.startService(serviceIntent)
                Log.d(TAG, "Started background service")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error starting background service: ${e.message}")
            e.printStackTrace()
        }
    }

    // Normalize phone number by removing country code if present
    private fun normalizePhoneNumber(phoneNumber: String): String {
        // Remove any non-digit characters except +
        val digitsOnly = phoneNumber.replace(Regex("[^0-9+]"), "")

        // If the number starts with a country code like +88, remove it
        return when {
            digitsOnly.startsWith("+88") -> {
                digitsOnly.substring(3) // Remove +88
            }
            digitsOnly.startsWith("+") -> {
                // For other country codes, try to remove the country code
                // This is a simplistic approach - in a real app, you might want to use a library
                val countryCodeEndIndex = digitsOnly.indexOfFirst { it.isDigit() } + 1
                if (countryCodeEndIndex > 0 && countryCodeEndIndex < digitsOnly.length) {
                    digitsOnly.substring(countryCodeEndIndex)
                } else {
                    digitsOnly
                }
            }
            else -> digitsOnly
        }
    }
}