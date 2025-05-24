# System Overlay Pop-up with Call Detection

This document explains the system overlay pop-up feature in your CRM app, which displays a contextual widget when a phone call ends. The pop-up provides actionable information about the caller, such as lead details and quick actions, if the number matches a lead in your CRM.

---

## How It Works

1. **Call Detection**: The app uses a native Android broadcast receiver (`CallStateReceiver.kt`) to listen for phone call state changes (incoming, outgoing, ended).
2. **Phone Number Matching**: When a call ends, the receiver notifies the Flutter side via a method channel. The app checks if the phone number matches any lead in the CRM database.
3. **Overlay Pop-up**: If a match is found, the app triggers a system overlay pop-up (using `OverlayService.kt` on Android) that displays lead information and quick actions. If no match is found, a generic pop-up is shown.
4. **User Actions**: The pop-up allows users to call back, view details, create tasks, follow up, and more, directly from the overlay.

---

## File Structure & Responsibilities

### Android (Native)

- **`android/app/src/main/kotlin/com/example/untitled1/CallStateReceiver.kt`**
  - Listens for phone call state changes.
  - Normalizes phone numbers and notifies Flutter via a method channel.
  - Starts the overlay service to display the pop-up.

- **`android/app/src/main/kotlin/com/example/untitled1/OverlayService.kt`**
  - Displays the overlay pop-up as a system window.
  - Handles UI actions (call back, add/view lead, create task, follow-up, update pipeline, close overlay).
  - Uses `overlay_layout.xml` for the UI.

- **`android/app/src/main/res/layout/overlay_layout.xml`**
  - Defines the layout for the overlay pop-up (name, phone, pipeline, action buttons).

- **`android/app/src/main/kotlin/com/example/untitled1/MainActivity.kt`**
  - Registers the broadcast receiver and manages permissions (including overlay permission).

### Flutter (Dart)

- **`lib/services/call_detection_service.dart`**
  - Handles communication with the native side via method channels.
  - Matches phone numbers to leads and triggers the appropriate pop-up widget.
  - Provides methods to check/request overlay permissions.

- **`lib/widgets/system_overlay_widget.dart`**
  - Main widget for displaying lead information and actions in a bottom sheet overlay.
  - Used when a matching lead is found.

- **`lib/widgets/call_popup_widget.dart`**
  - Alternative widget for displaying lead info in a pop-up (may be used in some flows).

- **`lib/widgets/simple_call_popup.dart`**
  - Widget for displaying a generic pop-up when no matching lead is found.

- **`lib/test-pages/call_detection_test_page.dart`**
  - Test page for simulating call detection and pop-up display in development.

---

## Required Permissions

The following permissions must be declared in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.READ_CALL_LOG" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

---

## Customization

- **Overlay UI**: Edit `overlay_layout.xml` (Android native) or `system_overlay_widget.dart` (Flutter) to change the appearance and actions of the pop-up.
- **Lead Matching Logic**: Update `call_detection_service.dart` to change how leads are matched to phone numbers.
- **Actions**: Add or modify actions in the overlay by editing the relevant widget or service files.

---

## Troubleshooting

- Ensure all required permissions are granted (especially SYSTEM_ALERT_WINDOW for overlays).
- Test the feature using the test page (`call_detection_test_page.dart`) in development.
- Check logs in both Android Studio (native) and Flutter for errors if the pop-up does not appear.

---

## Known Limitations

- Some Android devices may restrict background call detection or overlay permissions due to manufacturer or OS policies.
- Phone number formatting (country codes, etc.) may affect lead matching. Adjust normalization logic as needed.

---

## Example User Flow

1. User receives or makes a call.
2. When the call ends, the app detects the event and checks the number.
3. If the number matches a lead, a pop-up appears with lead info and actions (see screenshot above).
4. User can take quick actions (call back, view details, create task, follow-up, etc.) directly from the overlay.

---

For further details, see the code comments in each file or contact the development team. 