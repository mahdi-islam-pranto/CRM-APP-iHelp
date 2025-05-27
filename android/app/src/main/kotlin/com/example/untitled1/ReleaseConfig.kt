package com.example.untitled1

import android.content.Context
import android.util.Log

/**
 * Release configuration for system overlay and background services
 * Ensures all features work properly in release mode
 */
object ReleaseConfig {
    private const val TAG = "ReleaseConfig"
    
    // Feature flags for release mode
    const val ENABLE_SYSTEM_OVERLAY = true
    const val ENABLE_BACKGROUND_SERVICES = true
    const val ENABLE_CALL_DETECTION = true
    const val ENABLE_PERSISTENT_NOTIFICATION = true
    
    // Logging configuration for release
    const val ENABLE_RELEASE_LOGGING = true
    
    // Service restart configuration
    const val AUTO_RESTART_SERVICES = true
    const val SERVICE_RESTART_DELAY_MS = 5000L
    
    // Overlay configuration
    const val OVERLAY_AUTO_CLOSE_DELAY_MS = 30000L
    const val OVERLAY_SHOW_DURATION_MS = 15000L
    
    // Background service configuration
    const val FOREGROUND_SERVICE_NOTIFICATION_ID = 1001
    const val BACKGROUND_OPERATION_NOTIFICATION_ID = 999
    
    /**
     * Initialize release configuration
     */
    fun initialize(context: Context) {
        logRelease("Initializing release configuration...")
        
        // Verify all critical components
        verifySystemOverlaySupport(context)
        verifyBackgroundServiceSupport(context)
        verifyPermissions(context)
        
        logRelease("Release configuration initialized successfully")
    }
    
    /**
     * Verify system overlay support
     */
    private fun verifySystemOverlaySupport(context: Context): Boolean {
        return try {
            val hasPermission = android.provider.Settings.canDrawOverlays(context)
            logRelease("System overlay permission: $hasPermission")
            hasPermission
        } catch (e: Exception) {
            logRelease("Error checking system overlay support: ${e.message}")
            false
        }
    }
    
    /**
     * Verify background service support
     */
    private fun verifyBackgroundServiceSupport(context: Context): Boolean {
        return try {
            val packageManager = context.packageManager
            val hasPhonePermission = packageManager.checkPermission(
                android.Manifest.permission.READ_PHONE_STATE,
                context.packageName
            ) == android.content.pm.PackageManager.PERMISSION_GRANTED
            
            logRelease("Phone state permission: $hasPhonePermission")
            hasPhonePermission
        } catch (e: Exception) {
            logRelease("Error checking background service support: ${e.message}")
            false
        }
    }
    
    /**
     * Verify critical permissions
     */
    private fun verifyPermissions(context: Context) {
        val requiredPermissions = arrayOf(
            android.Manifest.permission.READ_PHONE_STATE,
            android.Manifest.permission.SYSTEM_ALERT_WINDOW,
            android.Manifest.permission.FOREGROUND_SERVICE,
            android.Manifest.permission.RECEIVE_BOOT_COMPLETED
        )
        
        val packageManager = context.packageManager
        for (permission in requiredPermissions) {
            val granted = packageManager.checkPermission(
                permission,
                context.packageName
            ) == android.content.pm.PackageManager.PERMISSION_GRANTED
            
            logRelease("Permission $permission: $granted")
        }
    }
    
    /**
     * Log messages in release mode (if enabled)
     */
    fun logRelease(message: String) {
        if (ENABLE_RELEASE_LOGGING) {
            Log.d(TAG, "[RELEASE] $message")
        }
    }
    
    /**
     * Log errors in release mode
     */
    fun logError(message: String, throwable: Throwable? = null) {
        if (ENABLE_RELEASE_LOGGING) {
            if (throwable != null) {
                Log.e(TAG, "[RELEASE ERROR] $message", throwable)
            } else {
                Log.e(TAG, "[RELEASE ERROR] $message")
            }
        }
    }
    
    /**
     * Check if feature is enabled in release mode
     */
    fun isFeatureEnabled(feature: String): Boolean {
        return when (feature) {
            "system_overlay" -> ENABLE_SYSTEM_OVERLAY
            "background_services" -> ENABLE_BACKGROUND_SERVICES
            "call_detection" -> ENABLE_CALL_DETECTION
            "persistent_notification" -> ENABLE_PERSISTENT_NOTIFICATION
            else -> false
        }
    }
}
