package com.example.untitled1

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject

class CallDetectionBackgroundService : Service() {
    companion object {
        private const val TAG = "CallDetectionBgService"
        private const val NOTIFICATION_ID = 2
        private const val CHANNEL_ID = "call_detection_bg_channel"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "CallDetectionBackgroundService onCreate")
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "CallDetectionBackgroundService onStartCommand - Service started!")

        try {
            // Start as foreground service
            val notification = createNotification()
            startForeground(NOTIFICATION_ID, notification)
            Log.d(TAG, "Foreground service started with notification")

            val phoneNumber = intent?.getStringExtra("phoneNumber")
            if (phoneNumber != null) {
                Log.d(TAG, "Processing call for number: $phoneNumber")
                processCallInBackground(phoneNumber)
            } else {
                Log.e(TAG, "No phone number provided in intent")
            }

            // Stop the service after processing
            Log.d(TAG, "Stopping background service")
            stopSelf()

        } catch (e: Exception) {
            Log.e(TAG, "Error in onStartCommand: ${e.message}")
            e.printStackTrace()
        }

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Call Detection Background",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Background call detection processing"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification() = NotificationCompat.Builder(this, CHANNEL_ID)
        .setContentTitle("Processing Call")
        .setContentText("Checking for matching lead...")
        .setSmallIcon(android.R.drawable.ic_menu_call)
        .setPriority(NotificationCompat.PRIORITY_LOW)
        .setAutoCancel(true)
        .build()

    private fun processCallInBackground(phoneNumber: String) {
        try {
            Log.d(TAG, "Processing call for number: $phoneNumber")

            // Normalize phone number
            val normalizedNumber = normalizePhoneNumber(phoneNumber)
            Log.d(TAG, "Normalized number: $normalizedNumber")

            // Check if there's a matching lead in local storage
            val matchingLead = findMatchingLeadInLocalStorage(normalizedNumber)

            if (matchingLead != null) {
                Log.d(TAG, "Found matching lead: ${matchingLead.getString("name")}")

                // Show overlay for matching lead
                showOverlayForLead(normalizedNumber, matchingLead)
            } else {
                Log.d(TAG, "No matching lead found for number: $normalizedNumber")
                // Don't show overlay for unknown numbers (as per requirement)
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error processing call in background: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun findMatchingLeadInLocalStorage(normalizedNumber: String): JSONObject? {
        try {
            val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val simplifiedLeadsJson = sharedPreferences.getString("flutter.simplified_leads", null)

            Log.d(TAG, "Looking for leads in local storage for number: $normalizedNumber")
            Log.d(TAG, "Simplified leads JSON exists: ${simplifiedLeadsJson != null}")

            if (simplifiedLeadsJson != null) {
                val simplifiedLeads = JSONArray(simplifiedLeadsJson)
                Log.d(TAG, "Found ${simplifiedLeads.length()} leads in local storage")

                for (i in 0 until simplifiedLeads.length()) {
                    val leadData = simplifiedLeads.getJSONObject(i)
                    val leadNumber = leadData.optString("phoneNumber", "")
                    val leadName = leadData.optString("name", "Unknown")

                    Log.d(TAG, "Checking lead $i: $leadName with number: $leadNumber")

                    if (leadNumber.isNotEmpty() && isPhoneNumberMatch(leadNumber, normalizedNumber)) {
                        Log.d(TAG, "Found matching lead in local storage: $leadName")
                        return leadData
                    }
                }
            } else {
                Log.w(TAG, "No simplified leads found in local storage")
            }

            Log.d(TAG, "No matching lead found in local storage for number: $normalizedNumber")
            return null
        } catch (e: Exception) {
            Log.e(TAG, "Error finding lead in local storage: ${e.message}")
            e.printStackTrace()
            return null
        }
    }

    private fun isPhoneNumberMatch(leadNumber: String, incomingNumber: String): Boolean {
        val normalizedLeadNumber = normalizePhoneNumber(leadNumber)
        val normalizedIncomingNumber = normalizePhoneNumber(incomingNumber)

        Log.d(TAG, "Comparing numbers: lead='$normalizedLeadNumber' vs incoming='$normalizedIncomingNumber'")

        // Check for exact match
        if (normalizedLeadNumber == normalizedIncomingNumber) {
            Log.d(TAG, "Exact match found!")
            return true
        }

        // Check if one number is a suffix of the other (for different country code formats)
        val minLength = 8 // Minimum significant digits to match
        if (normalizedLeadNumber.length >= minLength && normalizedIncomingNumber.length >= minLength) {
            val leadSuffix = normalizedLeadNumber.takeLast(minLength)
            val incomingSuffix = normalizedIncomingNumber.takeLast(minLength)
            if (leadSuffix == incomingSuffix) {
                Log.d(TAG, "Suffix match found! lead suffix='$leadSuffix' vs incoming suffix='$incomingSuffix'")
                return true
            }
        }

        Log.d(TAG, "No match found")
        return false
    }

    private fun showOverlayForLead(phoneNumber: String, leadData: JSONObject) {
        try {
            Log.d(TAG, "Showing overlay for lead: ${leadData.optString("name")}")

            // Set lead information in OverlayService
            OverlayService.leadName = leadData.optString("companyName", "Unknown Company")
            OverlayService.leadId = leadData.optInt("id", -1)
            OverlayService.hasMatchingLead = true
            OverlayService.leadPipeline = "N/A"
            OverlayService.assignedUser = "N/A"

            // Start overlay service
            val overlayIntent = Intent(this, OverlayService::class.java).apply {
                putExtra("phoneNumber", phoneNumber)
                putExtra("leadName", leadData.optString("companyName", "Unknown Company"))
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(overlayIntent)
                Log.d(TAG, "Started foreground overlay service")
            } else {
                startService(overlayIntent)
                Log.d(TAG, "Started overlay service")
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error showing overlay for lead: ${e.message}")
            e.printStackTrace()
        }
    }

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

    override fun onDestroy() {
        Log.d(TAG, "CallDetectionBackgroundService onDestroy")
        super.onDestroy()
    }
}
