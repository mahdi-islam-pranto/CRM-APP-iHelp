# System Overlay ProGuard Fix for Release Mode

## Problem
The system overlay popup feature was not working in release mode APK due to ProGuard obfuscation removing or renaming critical classes and methods needed for the overlay functionality.

## Solution Applied

### 1. Updated ProGuard Rules (`android/app/proguard-rules.pro`)

Added comprehensive ProGuard rules to protect all system overlay related components:

#### Critical Classes Protected:
- `CallStateReceiver` - Handles call state detection
- `OverlayService` - Displays the system overlay
- `MainActivity` - Manages method channels and permissions
- `AppReceiver` - Additional call receiver
- `TaskWidgetProvider` & `TaskWidgetService` - Widget components

#### Method Channel Communication Protected:
- Flutter method channel classes
- Method call handlers and results
- All public methods in MainActivity that are called from Flutter

#### Android Framework Classes Protected:
- BroadcastReceiver implementations
- Service implementations
- Activity implementations
- WindowManager and overlay-related classes
- TelephonyManager for call detection
- Notification classes

#### Static Variables and Companion Objects Protected:
- Call state management variables
- Lead information storage
- Callback listeners

### 2. Key ProGuard Rules Added:

```proguard
# System overlay critical classes
-keep class com.example.untitled1.CallStateReceiver { *; }
-keep class com.example.untitled1.OverlayService { *; }
-keep class com.example.untitled1.MainActivity { *; }

# Method channel communication
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Companion objects and static variables
-keep class com.example.untitled1.CallStateReceiver$Companion { *; }
-keep class com.example.untitled1.OverlayService$Companion { *; }

# Method names protection
-keepclassmembernames class com.example.untitled1.MainActivity {
    public ** showOverlayForLead(...);
    public ** checkOverlayPermission(...);
    public ** requestOverlayPermission(...);
    public ** startCallDetection(...);
    public ** stopCallDetection(...);
    public ** overlayPopUp(...);
}

# Android framework classes
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep class android.view.WindowManager { *; }
-keep class android.telephony.TelephonyManager { *; }
```

### 3. Additional Safety Measures:

- **Debugging Support**: Added rules to keep source file names and line numbers for better crash reports
- **Reflection Protection**: Protected classes that might be accessed via reflection
- **Lambda Expressions**: Protected synthetic lambda methods
- **Kotlin Support**: Protected Kotlin-specific classes and functions
- **Constructor Protection**: Ensured all constructors are preserved

## Testing Instructions

### 1. Build Release APK
```bash
flutter build apk --release
```

### 2. Install and Test
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 3. Test System Overlay Functionality

1. **Grant Permissions**: Ensure the app has:
   - Phone state permission
   - System alert window permission
   - Call log permission

2. **Test Call Detection**:
   - Make or receive a phone call
   - End the call
   - Verify that the overlay popup appears if there's a matching lead

3. **Test Method Channels**:
   - Use the test page (`call_detection_test_page.dart`) if available
   - Verify Flutter-Android communication works

4. **Check Logs**:
   ```bash
   adb logcat | grep -E "(CallStateReceiver|OverlayService|MainActivity)"
   ```

### 4. Verify No Crashes
- Monitor for any crashes related to missing classes
- Check that all method channel calls work properly
- Ensure overlay permissions are handled correctly

## What Was Fixed

1. **Class Obfuscation**: Prevented ProGuard from renaming critical classes
2. **Method Removal**: Protected all public methods called from Flutter
3. **Static Variable Access**: Preserved companion objects and static variables
4. **Reflection Issues**: Protected classes accessed via reflection
5. **Method Channel Communication**: Ensured Flutter-Android communication works
6. **Android Framework Integration**: Protected all Android system classes used

## Expected Results

After applying these fixes, the system overlay popup should work correctly in release mode:

- Call detection should function properly
- Overlay permission requests should work
- System overlay should display when calls end
- Method channel communication should be stable
- No crashes related to missing classes

## Troubleshooting

If issues persist:

1. **Check Logs**: Look for ClassNotFoundException or MethodNotFoundException
2. **Verify Permissions**: Ensure all required permissions are granted
3. **Test Method Channels**: Use Flutter's method channel debugging
4. **Add More Rules**: If specific classes are still being obfuscated, add them to ProGuard rules

## Files Modified

- `android/app/proguard-rules.pro` - Updated with comprehensive system overlay protection rules

## Backup

The original ProGuard rules have been preserved with comments. If needed, you can revert by removing the new sections marked with "SYSTEM OVERLAY" comments.
