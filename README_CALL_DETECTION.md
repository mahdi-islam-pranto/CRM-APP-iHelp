# Call Detection Feature

This feature allows the app to detect when a phone call ends and show a pop-up with lead information if the phone number matches a lead in the CRM.

## How It Works

1. The app registers a broadcast receiver to listen for phone call state changes.
2. When a call ends, the app checks if the phone number matches any lead in the CRM.
3. If a match is found, a pop-up is shown with the lead information.

## Required Permissions

The following permissions are required for this feature to work:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.READ_CALL_LOG" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

## Implementation Details

### Android Side

1. `CallStateReceiver.kt`: A broadcast receiver that listens for phone call state changes.
2. `MainActivity.kt`: Registers the broadcast receiver and sets up the method channel.

### Flutter Side

1. `call_detection_service.dart`: A service that handles call detection and lead matching.
2. `call_popup_widget.dart`: A widget that displays lead information in a pop-up.
3. `service_initializer.dart`: A widget that initializes the call detection service.

## Usage

The feature is automatically initialized when the app starts. No additional setup is required.

## Customization

You can customize the pop-up appearance by modifying the `call_popup_widget.dart` file.

## Troubleshooting

If the feature is not working, check the following:

1. Make sure the required permissions are granted.
2. Check if the broadcast receiver is properly registered.
3. Verify that the leads are properly loaded in the call detection service.

## Known Issues

- On some devices, the broadcast receiver may not receive the phone number for incoming calls due to privacy restrictions.
- The feature may not work on all devices due to manufacturer-specific restrictions.

## Future Improvements

- Add support for VoIP calls.
- Improve phone number matching to handle different formats.
- Add the ability to take notes directly from the pop-up. 