package com.example.untitled1

import android.Manifest
import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.untitled1/call_detection"
    private val PERMISSION_REQUEST_CODE = 100
    private val OVERLAY_PERMISSION_REQUEST_CODE = 101
    private val callStateReceiver = CallStateReceiver()
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize release configuration
        ReleaseConfig.initialize(this)
        ReleaseConfig.logRelease("MainActivity configureFlutterEngine - Release mode initialized")

        // Request permissions
        requestPermissions()

        // Note: CallStateReceiver is registered in AndroidManifest.xml for system-wide broadcasts
        // We only set up the Flutter callback here

        // Set up method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d(TAG, "Method call received: ${call.method}")
            when (call.method) {
                "startCallDetection" -> {
                    Log.d(TAG, "Starting call detection")
                    CallStateReceiver.callEndListener = { phoneNumber ->
                        Log.d(TAG, "Call ended, sending to Flutter: $phoneNumber")
                        activity.runOnUiThread {
                            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                                .invokeMethod("onCallEnded", phoneNumber)
                        }
                    }
                    result.success(true)
                }
                "stopCallDetection" -> {
                    Log.d(TAG, "Stopping call detection")
                    CallStateReceiver.callEndListener = null
                    result.success(true)
                }
                "requestOverlayPermission" -> {
                    Log.d(TAG, "Requesting overlay permission")
                    requestOverlayPermission()
                    result.success(true)
                }
                "checkOverlayPermission" -> {
                    Log.d(TAG, "Checking overlay permission")
                    val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val canDraw = Settings.canDrawOverlays(this)
                        Log.d(TAG, "Can draw overlays: $canDraw")
                        canDraw
                    } else {
                        Log.d(TAG, "SDK < M, assuming overlay permission granted")
                        true
                    }
                    Log.d(TAG, "Overlay permission result: $hasPermission")
                    result.success(hasPermission)
                }
                "showOverlayForLead" -> {
                    Log.d(TAG, "Showing overlay for matching lead")
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber") ?: ""
                        val leadName = call.argument<String>("leadName") ?: "Unknown"
                        val leadId = call.argument<Int>("leadId") ?: -1
                        val hasMatchingLead = call.argument<Boolean>("hasMatchingLead") ?: false
                        val leadPipeline = call.argument<String>("leadPipeline")
                        val assignedUser = call.argument<String>("assignedUser")

                        Log.d(TAG, "Lead info - Name: $leadName, Phone: $phoneNumber, ID: $leadId, HasMatch: $hasMatchingLead")
                        Log.d(TAG, "Pipeline: $leadPipeline, Assigned: $assignedUser")

                        // Store this information for the overlay service to use
                        OverlayService.leadName = leadName
                        OverlayService.leadId = leadId
                        OverlayService.hasMatchingLead = hasMatchingLead
                        OverlayService.leadPipeline = leadPipeline
                        OverlayService.assignedUser = assignedUser

                        // Now show the overlay
                        showOverlay(phoneNumber, leadName)

                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error showing overlay for lead: ${e.message}")
                        result.error("ERROR", "Failed to show overlay", e.message)
                    }
                }
                "dismissOverlay" -> {
                    Log.d(TAG, "Dismissing overlay")
                    try {
                        // Stop the overlay service
                        val intent = Intent(this, OverlayService::class.java)
                        stopService(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error dismissing overlay: ${e.message}")
                        result.error("ERROR", "Failed to dismiss overlay", e.message)
                    }
                }
                "requestBatteryOptimization" -> {
                    Log.d(TAG, "Requesting battery optimization exemption")
                    try {
                        requestBatteryOptimizationExemption()
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error requesting battery optimization exemption: ${e.message}")
                        result.error("ERROR", "Failed to request battery optimization exemption", e.message)
                    }
                }
                "requestAutoStartPermission" -> {
                    Log.d(TAG, "Requesting auto-start permission")
                    try {
                        requestAutoStartPermission()
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error requesting auto-start permission: ${e.message}")
                        result.error("ERROR", "Failed to request auto-start permission", e.message)
                    }
                }
                "showBackgroundOperationNotification" -> {
                    Log.d(TAG, "Showing background operation notification")
                    try {
                        showBackgroundOperationNotification()
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error showing background operation notification: ${e.message}")
                        result.error("ERROR", "Failed to show background operation notification", e.message)
                    }
                }
                "testBackgroundService" -> {
                    Log.d(TAG, "Testing background service")
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber") ?: "01645467222"

                        // Start the background service directly
                        val serviceIntent = Intent(this, CallDetectionBackgroundService::class.java).apply {
                            putExtra("phoneNumber", phoneNumber)
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(serviceIntent)
                            Log.d(TAG, "Started foreground background service for testing")
                        } else {
                            startService(serviceIntent)
                            Log.d(TAG, "Started background service for testing")
                        }

                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error testing background service: ${e.message}")
                        result.error("ERROR", "Failed to test background service", e.message)
                    }
                }
                "testCallStateReceiver" -> {
                    Log.d(TAG, "Testing CallStateReceiver directly")
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber") ?: "01645467222"

                        // Create a mock phone state intent
                        val mockIntent = Intent(TelephonyManager.ACTION_PHONE_STATE_CHANGED).apply {
                            putExtra(TelephonyManager.EXTRA_STATE, TelephonyManager.EXTRA_STATE_IDLE)
                            putExtra(TelephonyManager.EXTRA_INCOMING_NUMBER, phoneNumber)
                        }

                        // Set up the receiver state to simulate a call ending
                        CallStateReceiver.lastState = TelephonyManager.CALL_STATE_OFFHOOK
                        CallStateReceiver.lastPhoneNumber = phoneNumber

                        // Trigger the receiver directly
                        val receiver = CallStateReceiver()
                        receiver.onReceive(this, mockIntent)

                        Log.d(TAG, "CallStateReceiver test completed")
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error testing CallStateReceiver: ${e.message}")
                        result.error("ERROR", "Failed to test CallStateReceiver", e.message)
                    }
                }
                "startPhoneStateListener" -> {
                    Log.d(TAG, "Starting phone state listener service")
                    try {
                        // Check if service is already running
                        if (isServiceRunning(PhoneStateListenerService::class.java)) {
                            Log.d(TAG, "Phone state listener service is already running")
                            result.success(true)
                            return@setMethodCallHandler
                        }

                        val serviceIntent = Intent(this, PhoneStateListenerService::class.java)

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(serviceIntent)
                            Log.d(TAG, "Started foreground phone state listener service")
                        } else {
                            startService(serviceIntent)
                            Log.d(TAG, "Started phone state listener service")
                        }

                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error starting phone state listener service: ${e.message}")
                        result.error("ERROR", "Failed to start phone state listener service", e.message)
                    }
                }
                "stopPhoneStateListener" -> {
                    Log.d(TAG, "Stopping phone state listener service")
                    try {
                        val serviceIntent = Intent(this, PhoneStateListenerService::class.java)
                        stopService(serviceIntent)
                        Log.d(TAG, "Stopped phone state listener service")
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error stopping phone state listener service: ${e.message}")
                        result.error("ERROR", "Failed to stop phone state listener service", e.message)
                    }
                }
                "checkPhoneStateListenerStatus" -> {
                    Log.d(TAG, "Checking phone state listener service status")
                    try {
                        val isRunning = isServiceRunning(PhoneStateListenerService::class.java)
                        Log.d(TAG, "Phone state listener service running: $isRunning")
                        result.success(isRunning)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error checking phone state listener service status: ${e.message}")
                        result.error("ERROR", "Failed to check service status", e.message)
                    }
                }
                "getInitialIntent" -> {
                    Log.d(TAG, "Getting initial intent")
                    try {
                        val intent = activity.intent
                        val action = intent.getStringExtra("action")
                        val resultMap = HashMap<String, Any>()

                        if (action != null) {
                            resultMap["action"] = action

                            if (action == "view_lead") {
                                val leadId = intent.getIntExtra("lead_id", -1)
                                if (leadId > 0) {
                                    resultMap["lead_id"] = leadId
                                }
                            } else if (action == "add_lead") {
                                val phoneNumber = intent.getStringExtra("phone_number")
                                if (phoneNumber != null) {
                                    resultMap["phone_number"] = phoneNumber
                                }
                            } else if (action == "create_task") {
                                val leadId = intent.getIntExtra("lead_id", -1)
                                val phoneNumber = intent.getStringExtra("phone_number")
                                if (leadId > 0) {
                                    resultMap["lead_id"] = leadId
                                }
                                if (phoneNumber != null) {
                                    resultMap["phone_number"] = phoneNumber
                                }
                            } else if (action == "create_followup") {
                                val leadId = intent.getIntExtra("lead_id", -1)
                                val phoneNumber = intent.getStringExtra("phone_number")
                                if (leadId > 0) {
                                    resultMap["lead_id"] = leadId
                                }
                                if (phoneNumber != null) {
                                    resultMap["phone_number"] = phoneNumber
                                }
                            } else if (action == "update_pipeline") {
                                val leadId = intent.getIntExtra("lead_id", -1)
                                val phoneNumber = intent.getStringExtra("phone_number")
                                if (leadId > 0) {
                                    resultMap["lead_id"] = leadId
                                }
                                if (phoneNumber != null) {
                                    resultMap["phone_number"] = phoneNumber
                                }
                            }

                            Log.d(TAG, "Initial intent: $resultMap")
                            result.success(resultMap)
                        } else {
                            Log.d(TAG, "No action in initial intent")
                            result.success(null)
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Error getting initial intent: ${e.message}")
                        result.error("ERROR", "Failed to get initial intent", e.message)
                    }
                }
                else -> {
                    Log.e(TAG, "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val permissions = arrayOf(
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_CALL_LOG,
                Manifest.permission.PROCESS_OUTGOING_CALLS,
                Manifest.permission.SYSTEM_ALERT_WINDOW
            )

            val permissionsToRequest = permissions.filter {
                ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
            }.toTypedArray()

            if (permissionsToRequest.isNotEmpty()) {
                Log.d(TAG, "Requesting permissions: ${permissionsToRequest.joinToString()}")
                ActivityCompat.requestPermissions(
                    this,
                    permissionsToRequest,
                    PERMISSION_REQUEST_CODE
                )
            } else {
                Log.d(TAG, "All permissions already granted")
            }

            // Request overlay permission
            if (!Settings.canDrawOverlays(this)) {
                requestOverlayPermission()
            }
        }
    }

    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            Log.d(TAG, "Requesting overlay permission")
            Toast.makeText(this, "Please grant overlay permission to show popups after calls", Toast.LENGTH_LONG).show()
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == OVERLAY_PERMISSION_REQUEST_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (Settings.canDrawOverlays(this)) {
                    Log.d(TAG, "Overlay permission granted")
                    Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
                } else {
                    Log.d(TAG, "Overlay permission denied")
                    Toast.makeText(this, "Overlay permission denied", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE) {
            for (i in permissions.indices) {
                Log.d(TAG, "Permission ${permissions[i]}: ${if (grantResults[i] == PackageManager.PERMISSION_GRANTED) "GRANTED" else "DENIED"}")
            }
        }
    }

    private fun showOverlay(phoneNumber: String, leadName: String) {
        // Check if we have the overlay permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            Log.e(TAG, "Cannot show overlay - permission not granted")
            Toast.makeText(this, "Cannot show overlay - permission not granted", Toast.LENGTH_LONG).show()
            return
        }

        try {
            // Start the overlay service
            val intent = Intent(this, OverlayService::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                putExtra("phoneNumber", phoneNumber)
                putExtra("leadName", leadName)
            }

            Log.d(TAG, "Starting overlay service with number: $phoneNumber")

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    // For Android 12+ (API 31+), we need to specify the foreground service type
                    intent.putExtra("foregroundServiceType", 1) // 1 = FOREGROUND_SERVICE_TYPE_PHONE_CALL
                    startForegroundService(intent)
                    Log.d(TAG, "Started foreground service with type PHONE_CALL (Android 12+)")
                } else {
                    // For Android 8-11
                    startForegroundService(intent)
                    Log.d(TAG, "Started foreground service (Android 8-11)")
                }
            } else {
                // For Android 7 and below
                startService(intent)
                Log.d(TAG, "Started regular service (Android 7 and below)")
            }

            Log.d(TAG, "Started overlay service")
        } catch (e: Exception) {
            Log.e(TAG, "Error starting overlay service: ${e.message}")
            e.printStackTrace()
            Toast.makeText(this, "Error showing popup: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun requestBatteryOptimizationExemption() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(POWER_SERVICE) as PowerManager
            val packageName = packageName

            if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
                Log.d(TAG, "Requesting battery optimization exemption")
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:$packageName")
                }
                try {
                    startActivity(intent)
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting battery optimization settings: ${e.message}")
                    // Fallback to general battery optimization settings
                    try {
                        val fallbackIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                        startActivity(fallbackIntent)
                    } catch (e2: Exception) {
                        Log.e(TAG, "Error starting fallback battery optimization settings: ${e2.message}")
                    }
                }
            } else {
                Log.d(TAG, "App is already exempted from battery optimization")
            }
        }
    }

    private fun requestAutoStartPermission() {
        try {
            Log.d(TAG, "Attempting to request auto-start permission")

            // Different manufacturers have different auto-start settings
            val manufacturer = Build.MANUFACTURER.lowercase()
            val intent = when {
                manufacturer.contains("xiaomi") -> {
                    Intent().apply {
                        component = ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")
                    }
                }
                manufacturer.contains("huawei") -> {
                    Intent().apply {
                        component = ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
                    }
                }
                manufacturer.contains("oppo") -> {
                    Intent().apply {
                        component = ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")
                    }
                }
                manufacturer.contains("vivo") -> {
                    Intent().apply {
                        component = ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")
                    }
                }
                manufacturer.contains("samsung") -> {
                    Intent().apply {
                        component = ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")
                    }
                }
                else -> {
                    // Generic fallback - try to open app settings
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                        data = Uri.parse("package:$packageName")
                    }
                }
            }

            try {
                startActivity(intent)
                Log.d(TAG, "Auto-start permission intent started for $manufacturer")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start auto-start permission for $manufacturer: ${e.message}")
                // Fallback to app settings
                try {
                    val fallbackIntent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                        data = Uri.parse("package:$packageName")
                    }
                    startActivity(fallbackIntent)
                    Log.d(TAG, "Opened app settings as fallback")
                } catch (e2: Exception) {
                    Log.e(TAG, "Failed to open app settings: ${e2.message}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting auto-start permission: ${e.message}")
        }
    }

    private fun showBackgroundOperationNotification() {
        try {
            Log.d(TAG, "Showing background operation notification")

            // Create a notification to inform user about background operation
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channelId = "background_operation_channel"

            // Create notification channel for Android 8.0+
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    channelId,
                    "Background Operation",
                    NotificationManager.IMPORTANCE_DEFAULT
                ).apply {
                    description = "Notifications about app running in background"
                    setShowBadge(false)
                }
                notificationManager.createNotificationChannel(channel)
            }

            // Create intent to open the app
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                this, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val notification = NotificationCompat.Builder(this, channelId)
                .setContentTitle("iCRM Background Service")
                .setContentText("App is running in background to detect calls. Tap for settings.")
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setCategory(NotificationCompat.CATEGORY_STATUS)
                .build()

            notificationManager.notify(999, notification)
            Log.d(TAG, "Background operation notification shown")

        } catch (e: Exception) {
            Log.e(TAG, "Error showing background operation notification: ${e.message}")
        }
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                Log.d(TAG, "Service ${serviceClass.simpleName} is running")
                return true
            }
        }
        Log.d(TAG, "Service ${serviceClass.simpleName} is not running")
        return false
    }

    override fun onDestroy() {
        super.onDestroy()
        // Note: CallStateReceiver is registered in manifest, so no need to unregister
        // Just clear the Flutter callback
        CallStateReceiver.callEndListener = null
    }
}
