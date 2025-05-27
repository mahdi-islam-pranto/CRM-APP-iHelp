@echo off
setlocal enabledelayedexpansion

REM iCRM Release Build Script for Windows
REM Ensures all system overlay and background service features work in release mode

echo.
echo 🚀 Starting iCRM Release Build Process...
echo ================================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed or not in PATH
    pause
    exit /b 1
)

echo [INFO] Flutter version:
flutter --version

REM Clean previous builds
echo.
echo [INFO] Cleaning previous builds...
flutter clean
if errorlevel 1 (
    echo [ERROR] Clean failed
    pause
    exit /b 1
)
echo [SUCCESS] Clean completed

REM Get dependencies
echo.
echo [INFO] Getting Flutter dependencies...
flutter pub get
if errorlevel 1 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies retrieved

REM Verify critical files exist
echo.
echo [INFO] Verifying critical files for system overlay...

set "critical_files=android\app\src\main\kotlin\com\example\untitled1\MainActivity.kt android\app\src\main\kotlin\com\example\untitled1\OverlayService.kt android\app\src\main\kotlin\com\example\untitled1\CallStateReceiver.kt android\app\src\main\kotlin\com\example\untitled1\PhoneStateListenerService.kt android\app\src\main\kotlin\com\example\untitled1\BootReceiver.kt android\app\src\main\AndroidManifest.xml android\app\proguard-rules.pro"

for %%f in (%critical_files%) do (
    if exist "%%f" (
        echo [SUCCESS] ✓ %%f exists
    ) else (
        echo [ERROR] ✗ %%f is missing
        pause
        exit /b 1
    )
)

REM Check Android permissions in manifest
echo.
echo [INFO] Verifying Android permissions...
findstr /C:"android.permission.SYSTEM_ALERT_WINDOW" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [WARNING] ⚠ SYSTEM_ALERT_WINDOW permission not found
) else (
    echo [SUCCESS] ✓ SYSTEM_ALERT_WINDOW permission found
)

findstr /C:"android.permission.READ_PHONE_STATE" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [WARNING] ⚠ READ_PHONE_STATE permission not found
) else (
    echo [SUCCESS] ✓ READ_PHONE_STATE permission found
)

findstr /C:"android.permission.FOREGROUND_SERVICE" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [WARNING] ⚠ FOREGROUND_SERVICE permission not found
) else (
    echo [SUCCESS] ✓ FOREGROUND_SERVICE permission found
)

REM Check if services are registered in manifest
echo.
echo [INFO] Verifying services registration...
findstr /C:"OverlayService" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [ERROR] ✗ OverlayService not registered
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ OverlayService registered
)

findstr /C:"CallDetectionBackgroundService" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [ERROR] ✗ CallDetectionBackgroundService not registered
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ CallDetectionBackgroundService registered
)

findstr /C:"PhoneStateListenerService" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [ERROR] ✗ PhoneStateListenerService not registered
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ PhoneStateListenerService registered
)

REM Check if receivers are registered
echo.
echo [INFO] Verifying broadcast receivers...
findstr /C:"CallStateReceiver" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [ERROR] ✗ CallStateReceiver not registered
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ CallStateReceiver registered
)

findstr /C:"BootReceiver" android\app\src\main\AndroidManifest.xml >nul
if errorlevel 1 (
    echo [ERROR] ✗ BootReceiver not registered
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ BootReceiver registered
)

REM Verify proguard rules
echo.
echo [INFO] Verifying ProGuard rules for system overlay...
findstr /C:"com.example.untitled1.OverlayService" android\app\proguard-rules.pro >nul
if errorlevel 1 (
    echo [ERROR] ✗ OverlayService ProGuard rules missing
    pause
    exit /b 1
) else (
    echo [SUCCESS] ✓ OverlayService ProGuard rules found
)

REM Build release APK
echo.
echo [INFO] Building release APK...
echo [WARNING] This may take several minutes...
echo.

flutter build apk --release --verbose

if errorlevel 1 (
    echo [ERROR] Release APK build failed
    pause
    exit /b 1
)

echo [SUCCESS] Release APK built successfully!

REM Check if APK was created
set "APK_PATH=build\app\outputs\flutter-apk\app-release.apk"
if exist "%APK_PATH%" (
    echo [SUCCESS] APK created at: %APK_PATH%
    
    REM Get APK size
    for %%A in ("%APK_PATH%") do set "APK_SIZE=%%~zA"
    set /a "APK_SIZE_MB=!APK_SIZE! / 1024 / 1024"
    echo [INFO] APK size: !APK_SIZE_MB! MB
) else (
    echo [ERROR] APK not found at expected location
    pause
    exit /b 1
)

REM Create release notes
echo.
echo [INFO] Creating release notes...
set "RELEASE_NOTES=RELEASE_NOTES.md"

(
echo # iCRM Release Build
echo.
echo ## Build Information
echo - **Build Date**: %date% %time%
echo - **APK Location**: %APK_PATH%
echo - **APK Size**: !APK_SIZE_MB! MB
echo.
echo ## System Overlay Features ✅
echo - ✅ Native system overlay popup after call ends
echo - ✅ Lead information display in overlay
echo - ✅ Action buttons ^(Create Task, Follow-up, View Details^)
echo - ✅ Navigation from overlay to Flutter app
echo - ✅ SystemOverlayWidget integration
echo.
echo ## Background Service Features ✅
echo - ✅ Persistent call detection service
echo - ✅ Background operation when app is closed
echo - ✅ Auto-restart after device reboot
echo - ✅ Foreground service with notification
echo - ✅ Battery optimization handling
echo.
echo ## Release Mode Optimizations ✅
echo - ✅ ProGuard rules for system overlay classes
echo - ✅ Method channel protection
echo - ✅ Service and receiver preservation
echo - ✅ Release configuration initialization
echo.
echo ## Testing Checklist
echo Before deploying, test the following:
echo.
echo ### System Overlay Testing
echo - [ ] Close app completely
echo - [ ] Make a call to a lead number
echo - [ ] End the call
echo - [ ] Verify overlay appears with lead info
echo - [ ] Test all overlay buttons
echo - [ ] Verify navigation to Flutter app
echo.
echo ### Background Service Testing
echo - [ ] Verify persistent notification shows
echo - [ ] Test call detection with app closed
echo - [ ] Restart device and verify auto-start
echo - [ ] Check battery optimization settings
echo - [ ] Test auto-start permissions
echo.
echo ## Installation Instructions
echo 1. Enable "Install from unknown sources" in device settings
echo 2. Install the APK: `adb install %APK_PATH%`
echo 3. Grant all required permissions when prompted
echo 4. Test system overlay and background features
echo.
echo ## Troubleshooting
echo If system overlay doesn't work:
echo 1. Check overlay permission in Settings ^> Apps ^> iCRM ^> Display over other apps
echo 2. Disable battery optimization for iCRM
echo 3. Enable auto-start permission ^(Xiaomi, Huawei, etc.^)
echo 4. Ensure persistent notification is not disabled
) > "%RELEASE_NOTES%"

echo [SUCCESS] Release notes created: %RELEASE_NOTES%

echo.
echo ================================================
echo [SUCCESS] 🎉 iCRM Release Build Completed Successfully!
echo ================================================
echo [INFO] APK Location: %APK_PATH%
echo [INFO] Release Notes: %RELEASE_NOTES%
echo.
echo [WARNING] ⚠️  IMPORTANT: Test all system overlay and background features before deployment!
echo.
echo [INFO] Next steps:
echo 1. Install APK on test device
echo 2. Grant all permissions
echo 3. Test system overlay popup
echo 4. Test background call detection
echo 5. Verify auto-restart after reboot
echo.
echo [SUCCESS] Happy deploying! 🚀
echo.
pause
