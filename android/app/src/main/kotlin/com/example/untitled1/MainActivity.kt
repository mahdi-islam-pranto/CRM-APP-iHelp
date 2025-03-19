package com.example.untitled1

import android.Manifest
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
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
        
        // Request permissions
        requestPermissions()
        
        // Register call state receiver
        val intentFilter = IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
        intentFilter.addAction(Intent.ACTION_NEW_OUTGOING_CALL)
        registerReceiver(callStateReceiver, intentFilter)
        
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
                "updateOverlayWithLead" -> {
                    Log.d(TAG, "Updating overlay with lead information")
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber") ?: ""
                        val leadName = call.argument<String>("leadName") ?: "Unknown"
                        val leadId = call.argument<Int>("leadId") ?: -1
                        val hasMatchingLead = call.argument<Boolean>("hasMatchingLead") ?: false
                        
                        Log.d(TAG, "Lead info - Name: $leadName, Phone: $phoneNumber, ID: $leadId, HasMatch: $hasMatchingLead")
                        
                        // Store this information for the overlay service to use
                        OverlayService.leadName = leadName
                        OverlayService.leadId = leadId
                        OverlayService.hasMatchingLead = hasMatchingLead
                        
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error updating overlay with lead: ${e.message}")
                        result.error("ERROR", "Failed to update overlay", e.message)
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
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(callStateReceiver)
        } catch (e: Exception) {
            // Receiver not registered
            Log.e(TAG, "Error unregistering receiver: ${e.message}")
        }
    }
}
