#!/bin/bash

# iCRM Release Build Script
# Ensures all system overlay and background service features work in release mode

echo "🚀 Starting iCRM Release Build Process..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
if [ $? -eq 0 ]; then
    print_success "Clean completed"
else
    print_error "Clean failed"
    exit 1
fi

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_success "Dependencies retrieved"
else
    print_error "Failed to get dependencies"
    exit 1
fi

# Verify critical files exist
print_status "Verifying critical files for system overlay..."

critical_files=(
    "android/app/src/main/kotlin/com/example/untitled1/MainActivity.kt"
    "android/app/src/main/kotlin/com/example/untitled1/OverlayService.kt"
    "android/app/src/main/kotlin/com/example/untitled1/CallStateReceiver.kt"
    "android/app/src/main/kotlin/com/example/untitled1/PhoneStateListenerService.kt"
    "android/app/src/main/kotlin/com/example/untitled1/BootReceiver.kt"
    "android/app/src/main/AndroidManifest.xml"
    "android/app/proguard-rules.pro"
)

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        print_success "✓ $file exists"
    else
        print_error "✗ $file is missing"
        exit 1
    fi
done

# Check Android permissions in manifest
print_status "Verifying Android permissions..."
required_permissions=(
    "android.permission.SYSTEM_ALERT_WINDOW"
    "android.permission.READ_PHONE_STATE"
    "android.permission.FOREGROUND_SERVICE"
    "android.permission.RECEIVE_BOOT_COMPLETED"
    "android.permission.FOREGROUND_SERVICE_PHONE_CALL"
)

for permission in "${required_permissions[@]}"; do
    if grep -q "$permission" android/app/src/main/AndroidManifest.xml; then
        print_success "✓ Permission $permission found"
    else
        print_warning "⚠ Permission $permission not found"
    fi
done

# Check if services are registered in manifest
print_status "Verifying services registration..."
required_services=(
    "OverlayService"
    "CallDetectionBackgroundService"
    "PhoneStateListenerService"
)

for service in "${required_services[@]}"; do
    if grep -q "$service" android/app/src/main/AndroidManifest.xml; then
        print_success "✓ Service $service registered"
    else
        print_error "✗ Service $service not registered"
        exit 1
    fi
done

# Check if receivers are registered
print_status "Verifying broadcast receivers..."
required_receivers=(
    "CallStateReceiver"
    "BootReceiver"
)

for receiver in "${required_receivers[@]}"; do
    if grep -q "$receiver" android/app/src/main/AndroidManifest.xml; then
        print_success "✓ Receiver $receiver registered"
    else
        print_error "✗ Receiver $receiver not registered"
        exit 1
    fi
done

# Verify proguard rules for system overlay
print_status "Verifying ProGuard rules for system overlay..."
if grep -q "com.example.untitled1.OverlayService" android/app/proguard-rules.pro; then
    print_success "✓ OverlayService ProGuard rules found"
else
    print_error "✗ OverlayService ProGuard rules missing"
    exit 1
fi

# Build release APK
print_status "Building release APK..."
print_warning "This may take several minutes..."

flutter build apk --release --verbose

if [ $? -eq 0 ]; then
    print_success "Release APK built successfully!"
else
    print_error "Release APK build failed"
    exit 1
fi

# Check if APK was created
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    print_success "APK created at: $APK_PATH"
    
    # Get APK size
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    print_status "APK size: $APK_SIZE"
    
    # Get APK info
    print_status "APK information:"
    if command -v aapt &> /dev/null; then
        aapt dump badging "$APK_PATH" | grep -E "(package|sdkVersion|targetSdkVersion)"
    else
        print_warning "aapt not found, skipping APK analysis"
    fi
else
    print_error "APK not found at expected location"
    exit 1
fi

# Create release notes
RELEASE_NOTES="RELEASE_NOTES.md"
print_status "Creating release notes..."

cat > "$RELEASE_NOTES" << EOF
# iCRM Release Build

## Build Information
- **Build Date**: $(date)
- **Flutter Version**: $(flutter --version | head -n 1)
- **APK Location**: $APK_PATH
- **APK Size**: $APK_SIZE

## System Overlay Features ✅
- ✅ Native system overlay popup after call ends
- ✅ Lead information display in overlay
- ✅ Action buttons (Create Task, Follow-up, View Details)
- ✅ Navigation from overlay to Flutter app
- ✅ SystemOverlayWidget integration

## Background Service Features ✅
- ✅ Persistent call detection service
- ✅ Background operation when app is closed
- ✅ Auto-restart after device reboot
- ✅ Foreground service with notification
- ✅ Battery optimization handling

## Release Mode Optimizations ✅
- ✅ ProGuard rules for system overlay classes
- ✅ Method channel protection
- ✅ Service and receiver preservation
- ✅ Release configuration initialization

## Testing Checklist
Before deploying, test the following:

### System Overlay Testing
- [ ] Close app completely
- [ ] Make a call to a lead number
- [ ] End the call
- [ ] Verify overlay appears with lead info
- [ ] Test all overlay buttons
- [ ] Verify navigation to Flutter app

### Background Service Testing
- [ ] Verify persistent notification shows
- [ ] Test call detection with app closed
- [ ] Restart device and verify auto-start
- [ ] Check battery optimization settings
- [ ] Test auto-start permissions

### Permissions Testing
- [ ] System overlay permission
- [ ] Phone state permission
- [ ] Battery optimization exemption
- [ ] Auto-start permission (device-specific)

## Installation Instructions
1. Enable "Install from unknown sources" in device settings
2. Install the APK: \`adb install $APK_PATH\`
3. Grant all required permissions when prompted
4. Test system overlay and background features

## Troubleshooting
If system overlay doesn't work:
1. Check overlay permission in Settings > Apps > iCRM > Display over other apps
2. Disable battery optimization for iCRM
3. Enable auto-start permission (Xiaomi, Huawei, etc.)
4. Ensure persistent notification is not disabled

## Technical Notes
- Minimum SDK: 23 (Android 6.0)
- Target SDK: Latest Flutter target
- ProGuard: Enabled with custom rules
- Foreground Service Type: phoneCall
- Network Security: Custom config for API endpoints
EOF

print_success "Release notes created: $RELEASE_NOTES"

echo ""
echo "================================================"
print_success "🎉 iCRM Release Build Completed Successfully!"
echo "================================================"
print_status "APK Location: $APK_PATH"
print_status "Release Notes: $RELEASE_NOTES"
echo ""
print_warning "⚠️  IMPORTANT: Test all system overlay and background features before deployment!"
echo ""
print_status "Next steps:"
echo "1. Install APK on test device"
echo "2. Grant all permissions"
echo "3. Test system overlay popup"
echo "4. Test background call detection"
echo "5. Verify auto-restart after reboot"
echo ""
print_success "Happy deploying! 🚀"
EOF
