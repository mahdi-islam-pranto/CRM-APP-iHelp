package com.example.untitled1

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.os.Handler
import android.provider.Settings
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.MethodChannel

class OverlayService : Service() {
    companion object {
        private const val TAG = "OverlayService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "call_overlay_channel"
        
        // Static variables to store lead information
        var leadName: String? = null
        var leadId: Int = -1
        var hasMatchingLead: Boolean = false
    }
    
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var phoneNumber: String? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "OverlayService onCreate")
        createNotificationChannel()
        
        // Create and start foreground service with the appropriate type
        val notification = createNotification()
        
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                Log.d(TAG, "Starting foreground service with notification")
                startForeground(NOTIFICATION_ID, notification)
            } else {
                Log.d(TAG, "Starting foreground service with notification (pre-Q)")
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error starting foreground service: ${e.message}")
            e.printStackTrace()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service onStartCommand called with flags=$flags, startId=$startId")
        
        try {
            if (intent != null) {
                phoneNumber = intent.getStringExtra("phoneNumber")
                
                // Use the lead name from the companion object if available
                val displayName = if (hasMatchingLead && leadName != null) {
                    Log.d(TAG, "Using lead name from Flutter: $leadName (ID: $leadId)")
                    leadName
                } else {
                    // Fallback to the default format
                    val defaultName = intent.getStringExtra("leadName") ?: "Call from $phoneNumber"
                    Log.d(TAG, "Using default lead name: $defaultName")
                    defaultName
                }
                
                Log.d(TAG, "Showing overlay for number: $phoneNumber, name: $displayName")
                
                // Show the overlay with a slight delay to ensure the service is fully started
                Handler().postDelayed({
                    try {
                        showOverlay()
                    } catch (e: Exception) {
                        Log.e(TAG, "Error in delayed showOverlay: ${e.message}")
                        e.printStackTrace()
                    }
                }, 500)
            } else {
                Log.e(TAG, "Intent is null in onStartCommand")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onStartCommand: ${e.message}")
            e.printStackTrace()
        }
        
        return START_NOT_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Call Overlay"
            val descriptionText = "Shows overlay after calls"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        Log.d(TAG, "Creating notification for foreground service")
        
        // Create a pending intent for the notification
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )

        // Determine the notification content based on whether we have a matching lead
        val notificationTitle = if (hasMatchingLead) "Lead Found" else "Call Information"
        val notificationContent = if (hasMatchingLead && leadName != null) {
            leadName // Use the lead name directly
        } else if (phoneNumber != null) {
            "Call from $phoneNumber"
        } else {
            "Call detected"
        }

        // Build the notification
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(notificationTitle)
            .setContentText(notificationContent)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setOngoing(true)
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // For Android 12+, set the foreground service type
            builder.setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
        }
        
        return builder.build()
    }

    private fun showOverlay() {
        Log.d(TAG, "showOverlay called for number: $phoneNumber")
        
        try {
            // Check if we have the overlay permission
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                Log.e(TAG, "Cannot show overlay - permission not granted")
                Toast.makeText(this, "Cannot show overlay - permission not granted", Toast.LENGTH_LONG).show()
                stopSelf()
                return
            }
            
            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
            
            val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
            overlayView = inflater.inflate(R.layout.overlay_layout, null)
            
            // Set the phone number and name
            val nameTextView = overlayView?.findViewById<TextView>(R.id.textViewName)
            val phoneTextView = overlayView?.findViewById<TextView>(R.id.textViewPhone)
            val addLeadButton = overlayView?.findViewById<Button>(R.id.buttonAddLead)
            
            // Format the phone number for display
            val formattedPhoneNumber = formatPhoneNumber(phoneNumber ?: "")
            
            // Set the name based on whether we have a matching lead
            if (hasMatchingLead && leadName != null) {
                nameTextView?.text = leadName
                phoneTextView?.text = formattedPhoneNumber
                // Change the button text to "View Details" for existing leads
                addLeadButton?.text = "View Details"
            } else {
                nameTextView?.text = "Unknown Contact"
                phoneTextView?.text = formattedPhoneNumber
                // Keep the button text as "Add as Lead" for unknown numbers
                addLeadButton?.text = "Add as Lead"
            }
            
            Log.d(TAG, "Setting up overlay buttons")
            
            // Set up buttons
            overlayView?.findViewById<Button>(R.id.buttonCall)?.setOnClickListener {
                // Call the number
                val dialIntent = Intent(Intent.ACTION_DIAL)
                dialIntent.data = android.net.Uri.parse("tel:$phoneNumber")
                dialIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(dialIntent)
                
                // Close the overlay
                removeOverlay()
            }
            
            overlayView?.findViewById<Button>(R.id.buttonAddLead)?.setOnClickListener {
                // Open the app with the appropriate action
                val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    
                    // Add extras to indicate what to do
                    if (hasMatchingLead && leadId > 0) {
                        // View existing lead
                        putExtra("action", "view_lead")
                        putExtra("lead_id", leadId)
                    } else {
                        
                        // Add new lead
                        putExtra("action", "add_lead")
                        putExtra("phone_number", phoneNumber)

                        
                    }
                }
                
                launchIntent?.let { startActivity(it) }
                
                // Close the overlay
                removeOverlay()
            }
            
            overlayView?.findViewById<Button>(R.id.buttonClose)?.setOnClickListener {
                // Close the overlay
                removeOverlay()
            }
            
            Log.d(TAG, "Creating window parameters")
            
            // Create layout parameters for the overlay
            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                } else {
                    WindowManager.LayoutParams.TYPE_PHONE
                },
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
                PixelFormat.TRANSLUCENT
            )
            
            // Position at the bottom of the screen
            params.gravity = Gravity.BOTTOM
            
            try {
                // Add the view to the window
                Log.d(TAG, "Adding view to window")
                windowManager?.addView(overlayView, params)
                Log.d(TAG, "Overlay added to window successfully")
            } catch (e: Exception) {
                Log.e(TAG, "Error showing overlay: ${e.message}")
                e.printStackTrace()
                Toast.makeText(this, "Error showing overlay: ${e.message}", Toast.LENGTH_LONG).show()
                stopSelf()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in showOverlay: ${e.message}")
            e.printStackTrace()
            stopSelf()
        }
    }
    
    private fun removeOverlay() {
        if (overlayView != null && windowManager != null) {
            try {
                windowManager?.removeView(overlayView)
                Log.d(TAG, "Overlay removed")
            } catch (e: Exception) {
                Log.e(TAG, "Error removing overlay: ${e.message}")
            } finally {
                overlayView = null
            }
        }
        
        // Stop the service
        stopSelf()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        removeOverlay()
    }

    // Format phone number for better readability
    private fun formatPhoneNumber(phoneNumber: String): String {
        // Remove any non-digit characters
        val digitsOnly = phoneNumber.replace(Regex("[^0-9+]"), "")
        
        // If it's already formatted or too short, return as is
        if (digitsOnly.length < 10 || digitsOnly.contains(" ")) {
            return digitsOnly
        }
        
        // Format based on length and whether it has country code
        return when {
            // For Bangladesh numbers with country code (+88)
            digitsOnly.startsWith("+88") && digitsOnly.length >= 13 -> {
                val number = digitsOnly.substring(3) // Remove +88
                "+88 ${number.substring(0, 5)} ${number.substring(5)}"
            }
            // For numbers with country code but not +88
            digitsOnly.startsWith("+") -> {
                // Try to format with spaces for readability
                val parts = digitsOnly.chunked(4)
                parts.joinToString(" ")
            }
            // For 11-digit Bangladesh numbers without country code
            digitsOnly.length == 11 && (digitsOnly.startsWith("01") || digitsOnly.startsWith("1")) -> {
                if (digitsOnly.startsWith("01")) {
                    "${digitsOnly.substring(0, 5)} ${digitsOnly.substring(5)}"
                } else {
                    "0${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}"
                }
            }
            // Default formatting for other numbers
            else -> {
                val parts = digitsOnly.chunked(4)
                parts.joinToString(" ")
            }
        }
    }
}
