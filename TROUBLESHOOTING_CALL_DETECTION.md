# Troubleshooting Call Detection Feature

If you're experiencing issues with the call detection feature, follow these steps to diagnose and fix the problem:

## 1. Check Permissions

The call detection feature requires several permissions to work properly:

- **READ_PHONE_STATE**: Required to detect phone calls
- **READ_CALL_LOG**: Required to access call details
- **SYSTEM_ALERT_WINDOW**: Required to show the popup over other apps

To check and grant these permissions:

1. Go to your device's **Settings**
2. Navigate to **Apps** or **Application Manager**
3. Find and tap on the **iCRM** app
4. Tap on **Permissions**
5. Make sure all the required permissions are granted

## 2. Test the Feature

The app includes a test page to verify if the call detection feature is working properly:

1. Open the app
2. Look for the "Test Call Detection" button on the splash screen (top-right corner)
3. Enter a phone number that matches one of your leads
4. Tap "Test Call Detection" to simulate a call end event
5. Check if the popup appears with the lead information

## 3. Check Logs

If the popup doesn't appear, check the logs for any errors:

1. Connect your device to a computer
2. Enable USB debugging on your device
3. Run `adb logcat | grep CallState` in a terminal to see call-related logs
4. Look for any error messages or warnings

## 4. Common Issues and Solutions

### Popup Not Appearing

- **Issue**: The popup doesn't appear after a call ends
- **Solution**: Make sure the SYSTEM_ALERT_WINDOW permission is granted and the app is running in the background

### Phone Number Not Detected

- **Issue**: The app doesn't detect the phone number of the call
- **Solution**: Some devices restrict access to phone numbers for privacy reasons. Try using the test page to manually test the feature.

### No Matching Lead Found

- **Issue**: The app detects the call but doesn't find a matching lead
- **Solution**: Make sure the phone number format in your leads matches the format of the detected phone number. The app normalizes phone numbers by removing non-digit characters, but country codes might cause issues.

## 5. Contact Support

If you're still experiencing issues after following these steps, please contact our support team with the following information:

- Device model and Android version
- Steps to reproduce the issue
- Any error messages from the logs
- Screenshots of the permissions settings

## 6. Known Limitations

- On some Android devices (especially newer versions), the system may restrict background apps from accessing call information for privacy reasons
- The feature may not work if the app is killed by the system's battery optimization
- Some phone number formats may not be correctly matched due to differences in formatting (e.g., country codes) 