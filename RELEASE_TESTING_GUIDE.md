# iCRM Release APK Testing Guide

## 🎯 Overview
This guide ensures all system overlay popup and background service features work properly in the release APK.

## 📋 Pre-Installation Checklist

### Device Requirements
- [ ] Android 6.0+ (API level 23+)
- [ ] At least 100MB free storage
- [ ] SIM card with active phone service
- [ ] Test phone numbers in your CRM system

### Developer Settings
- [ ] Enable "USB Debugging" (for ADB installation)
- [ ] Enable "Install from unknown sources" or "Install unknown apps"

## 🚀 Installation Process

### Method 1: ADB Installation (Recommended)
```bash
# Connect device via USB
adb devices

# Install the APK
adb install build/app/outputs/flutter-apk/app-release.apk

# If app already exists, use -r flag to replace
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Method 2: Direct Installation
1. Copy APK to device storage
2. Open file manager and tap the APK
3. Follow installation prompts
4. Grant "Install from unknown sources" if prompted

## 🔐 Permission Setup (Critical!)

### 1. System Overlay Permission
**Location**: Settings > Apps > iCRM > Display over other apps
- [ ] Enable "Display over other apps"
- [ ] Verify permission is granted

### 2. Phone Permissions
**Location**: Settings > Apps > iCRM > Permissions
- [ ] Phone: Allow
- [ ] Contacts: Allow (if needed)

### 3. Battery Optimization (Essential!)
**Location**: Settings > Battery > Battery Optimization
- [ ] Find iCRM in the list
- [ ] Select "Don't optimize"
- [ ] Confirm the setting

### 4. Auto-Start Permission (Device Specific)

#### Xiaomi/MIUI
- Settings > Apps > Manage apps > iCRM > Auto-start: Enable

#### Huawei/EMUI
- Settings > Apps > Apps > iCRM > Battery > App launch: Manual manage
- Enable: Auto-launch, Secondary launch, Run in background

#### OPPO/ColorOS
- Settings > Apps > App list > iCRM > Allow auto-start

#### Vivo/FunTouch OS
- Settings > More settings > Applications > Autostart > iCRM: Enable

#### Samsung/One UI
- Settings > Device care > Battery > App power management > iCRM: Disable

### 5. Notification Permissions (Android 13+)
- [ ] Allow notifications when prompted
- [ ] Verify persistent notification can be shown

## 🧪 System Overlay Testing

### Test 1: Basic Overlay Functionality
1. **Setup**:
   - [ ] Open iCRM app
   - [ ] Ensure you have test lead numbers in the system
   - [ ] Close the app completely (remove from recent apps)

2. **Test Steps**:
   - [ ] Call a number that exists in your CRM leads
   - [ ] Let it ring for a few seconds
   - [ ] End the call
   - [ ] **Expected**: Native overlay popup appears within 5 seconds

3. **Verify Overlay Content**:
   - [ ] Lead/company name is displayed correctly
   - [ ] Phone number is shown
   - [ ] All action buttons are visible:
     - [ ] Create Task
     - [ ] Create Follow-up
     - [ ] View Details
     - [ ] Update Pipeline
     - [ ] Make Note
     - [ ] Call Again

### Test 2: Overlay Button Actions
For each button, test the following:

#### Create Task Button
1. [ ] Press "Create Task" on overlay
2. [ ] App opens and shows SystemOverlayWidget first
3. [ ] After short delay, navigates to LeadTaskCreateForm
4. [ ] Correct lead ID is passed to the form
5. [ ] Can create task successfully

#### Create Follow-up Button
1. [ ] Press "Create Follow-up" on overlay
2. [ ] App opens and shows SystemOverlayWidget first
3. [ ] After short delay, navigates to LeadFollowUpCreate
4. [ ] Correct lead ID is passed to the form
5. [ ] Can create follow-up successfully

#### View Details Button
1. [ ] Press "View Details" on overlay
2. [ ] App opens and shows SystemOverlayWidget first
3. [ ] After short delay, navigates to LeadDetailsTabs
4. [ ] Correct lead information is displayed
5. [ ] All tabs (Overview, Follow-up, Task) work properly

#### Update Pipeline Button
1. [ ] Press "Update Pipeline" on overlay
2. [ ] App opens and shows SystemOverlayWidget first
3. [ ] After short delay, navigates to LeadDetailsTabs
4. [ ] Can access pipeline management features

### Test 3: SystemOverlayWidget Integration
1. [ ] When app opens from overlay, SystemOverlayWidget appears as bottom sheet
2. [ ] Lead information is correctly displayed in widget
3. [ ] All widget buttons work:
   - [ ] Create Task
   - [ ] Create Follow-up
   - [ ] View Details
   - [ ] Call Again
   - [ ] Make Note
4. [ ] Can dismiss widget by tapping outside or close button

## 🔄 Background Service Testing

### Test 1: Persistent Notification
1. [ ] Open iCRM app
2. [ ] Check notification panel
3. [ ] **Expected**: "iCRM Always Running" notification is visible
4. [ ] Notification shows "Call detection active - Tap to open app"
5. [ ] Tapping notification opens the app

### Test 2: Background Call Detection
1. [ ] Close iCRM app completely
2. [ ] Verify persistent notification is still showing
3. [ ] Make test calls to lead numbers
4. [ ] **Expected**: Overlay appears for each call even with app closed
5. [ ] Test multiple calls in sequence

### Test 3: Service Restart After Reboot
1. [ ] Restart the device completely
2. [ ] Wait for device to fully boot
3. [ ] Check notification panel
4. [ ] **Expected**: "iCRM Always Running" notification appears automatically
5. [ ] Test call detection works immediately after reboot

### Test 4: Service Persistence
1. [ ] Open Android Settings > Apps > iCRM > Force Stop
2. [ ] Wait 30 seconds
3. [ ] Check if service restarts automatically
4. [ ] Test call detection still works

## 🐛 Troubleshooting Common Issues

### Issue: Overlay Doesn't Appear
**Possible Causes & Solutions**:
- [ ] Check overlay permission: Settings > Apps > iCRM > Display over other apps
- [ ] Disable battery optimization: Settings > Battery > Battery Optimization > iCRM > Don't optimize
- [ ] Enable auto-start: Device-specific settings (see above)
- [ ] Check if persistent notification is showing
- [ ] Restart the app and try again

### Issue: App Doesn't Open from Overlay
**Possible Causes & Solutions**:
- [ ] Check if app is installed correctly
- [ ] Verify app permissions are granted
- [ ] Clear app cache: Settings > Apps > iCRM > Storage > Clear Cache
- [ ] Reinstall the app

### Issue: Background Service Stops
**Possible Causes & Solutions**:
- [ ] Check battery optimization settings
- [ ] Verify auto-start permission
- [ ] Check if persistent notification is disabled
- [ ] Look for aggressive power management settings

### Issue: SystemOverlayWidget Doesn't Show
**Possible Causes & Solutions**:
- [ ] Check app logs for errors
- [ ] Verify lead data is properly loaded
- [ ] Test with different lead numbers
- [ ] Restart the app

## 📊 Performance Testing

### Memory Usage
- [ ] Monitor app memory usage during background operation
- [ ] Should remain stable under 100MB
- [ ] No memory leaks during extended use

### Battery Impact
- [ ] Monitor battery usage over 24 hours
- [ ] Should be minimal impact (< 5% daily usage)
- [ ] Persistent notification should not drain battery excessively

### Response Time
- [ ] Overlay should appear within 5 seconds of call end
- [ ] App should open within 3 seconds from overlay tap
- [ ] Navigation should be smooth and responsive

## ✅ Final Verification Checklist

### Core Functionality
- [ ] System overlay popup works when app is closed
- [ ] All overlay buttons navigate to correct pages
- [ ] SystemOverlayWidget shows first before navigation
- [ ] Background service runs persistently
- [ ] Auto-restart after device reboot works
- [ ] Persistent notification is always visible

### Edge Cases
- [ ] Multiple rapid calls handled correctly
- [ ] Overlay works with unknown numbers (if configured)
- [ ] Service survives force-stop and restarts
- [ ] Works correctly after app updates
- [ ] Handles low memory situations gracefully

### User Experience
- [ ] Permissions are requested appropriately
- [ ] User is informed about background operation
- [ ] Navigation flow is intuitive
- [ ] No crashes or ANRs during testing
- [ ] All features work as expected

## 📝 Test Results Documentation

Create a test report with:
- [ ] Device model and Android version
- [ ] Test date and duration
- [ ] All test results (pass/fail)
- [ ] Any issues encountered
- [ ] Performance observations
- [ ] Screenshots of successful tests

## 🚀 Deployment Readiness

The release APK is ready for deployment when:
- [ ] All core functionality tests pass
- [ ] No critical issues found
- [ ] Performance is acceptable
- [ ] User experience is smooth
- [ ] All edge cases handled properly

**Remember**: Test on multiple devices and Android versions if possible for comprehensive validation!
