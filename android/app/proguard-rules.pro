# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Flutter Method Channels - Critical for system overlay communication
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class io.flutter.plugin.common.MethodCall { *; }
-keep class io.flutter.plugin.common.MethodChannel$Result { *; }

# VoIP24h SDK
-keep class voip24h.sdk.mobile.voip24h_sdk_mobile.** { *; }

# ===== SYSTEM OVERLAY POPUP CRITICAL CLASSES =====
# Keep all system overlay related classes - ESSENTIAL for release mode
-keep class com.example.untitled1.CallStateReceiver { *; }
-keep class com.example.untitled1.OverlayService { *; }
-keep class com.example.untitled1.MainActivity { *; }

# Keep other receivers and services mentioned in AndroidManifest.xml
-keep class com.example.untitled1.AppReceiver { *; }
-keep class com.example.untitled1.TaskWidgetProvider { *; }
-keep class com.example.untitled1.TaskWidgetService { *; }

# Keep companion objects and static variables - needed for call state management
-keep class com.example.untitled1.CallStateReceiver$Companion { *; }
-keep class com.example.untitled1.OverlayService$Companion { *; }

# Keep all methods that might be called via reflection or method channels
-keepclassmembers class com.example.untitled1.MainActivity {
    public void showOverlayForLead(java.util.Map);
    public boolean checkOverlayPermission();
    public void requestOverlayPermission();
    public void startCallDetection();
    public void stopCallDetection();
    public void overlayPopUp(java.util.Map);
}

# Keep BroadcastReceiver methods
-keepclassmembers class com.example.untitled1.CallStateReceiver {
    public void onReceive(android.content.Context, android.content.Intent);
    public static ** lastState;
    public static ** lastPhoneNumber;
    public static ** callEndListener;
}

# Keep BootReceiver
-keep class com.example.untitled1.BootReceiver {
    public void onReceive(android.content.Context, android.content.Intent);
}

# Keep OverlayService methods and fields
-keep class com.example.untitled1.OverlayService {
    public *;
    private *;
}
-keepclassmembers class com.example.untitled1.OverlayService {
    public static ** leadName;
    public static ** leadId;
    public static ** hasMatchingLead;
    public static ** leadPipeline;
    public static ** assignedUser;
}

# Keep CallDetectionBackgroundService
-keep class com.example.untitled1.CallDetectionBackgroundService {
    public *;
    private *;
}

# Keep PhoneStateListenerService
-keep class com.example.untitled1.PhoneStateListenerService {
    public *;
    private *;
}

# Keep all broadcast receivers
-keep class * extends android.content.BroadcastReceiver {
    public void onReceive(android.content.Context, android.content.Intent);
}

# Keep all services
-keep class * extends android.app.Service {
    public *;
}

# Keep method channel related classes
-keep class io.flutter.plugin.common.MethodChannel {
    public *;
}
-keep class io.flutter.plugin.common.MethodCall {
    public *;
}
-keep class io.flutter.plugin.common.MethodChannel$Result {
    public *;
}

# Keep Service methods and static variables
-keepclassmembers class com.example.untitled1.OverlayService {
    public android.os.IBinder onBind(android.content.Intent);
    public int onStartCommand(android.content.Intent, int, int);
    public void onCreate();
    public void onDestroy();
    public static ** leadName;
    public static ** leadId;
    public static ** hasMatchingLead;
    public static ** leadPipeline;
    public static ** assignedUser;
}

# Your SIP-related classes
#-keep class com.example.untitled1.SIPConfiguration { *; }
#-keep class com.example.untitled1.SIPCredential { *; }
#-keep class com.example.untitled1.SipAccountStatus { *; }

# If you're using any external libraries for SIP, add rules for them here

# Preserve all native method names and the names of their classes.
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve all classes that have special context - UNCOMMENTED for system overlay
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

# Preserve all View implementations, their special context constructors, and
# their setters - UNCOMMENTED for overlay views
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

# Preserve Parcelables - UNCOMMENTED for Intent data
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# ===== ADDITIONAL SYSTEM OVERLAY RULES =====
# Keep WindowManager and related classes for overlay display
-keep class android.view.WindowManager { *; }
-keep class android.view.WindowManager$LayoutParams { *; }
-keep class android.provider.Settings { *; }

# Keep TelephonyManager for call state detection
-keep class android.telephony.TelephonyManager { *; }

# Keep Intent and Bundle classes for data passing
-keep class android.content.Intent { *; }
-keep class android.os.Bundle { *; }

# Keep Handler and Runnable for delayed operations
-keep class android.os.Handler { *; }
-keep class java.lang.Runnable { *; }

# Keep notification related classes
-keep class android.app.NotificationManager { *; }
-keep class android.app.NotificationChannel { *; }
-keep class androidx.core.app.NotificationCompat { *; }
-keep class androidx.core.app.NotificationCompat$Builder { *; }

# Keep lambda expressions and functional interfaces
-keepclassmembers class * {
    public static synthetic lambda*(...);
}

# Keep Kotlin-specific classes that might be used
-keep class kotlin.jvm.functions.Function* { *; }
-keep class kotlin.Unit { *; }

# Keep method channel callback interfaces
-keep interface io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep interface io.flutter.plugin.common.MethodChannel$Result { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Preserve enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ===== SYSTEM OVERLAY DEBUGGING RULES =====
# Keep all classes in your package for easier debugging in release mode
-keep class com.example.untitled1.** { *; }

# Keep all method names for better stack traces
-keepattributes SourceFile,LineNumberTable

# Keep method signatures for reflection
-keepattributes Signature

# Keep annotations that might be used by reflection
-keepattributes *Annotation*

# Keep inner classes
-keepattributes InnerClasses,EnclosingMethod

# ===== FLUTTER SPECIFIC OVERLAY RULES =====
# Keep all classes that might be accessed from Flutter via method channels
-keep class * {
    @io.flutter.plugin.common.MethodChannel$MethodCallHandler *;
}

# Keep all public methods that might be called from Flutter
-keepclassmembers class com.example.untitled1.** {
    public *;
}

# Keep all static fields and methods that might be accessed
-keepclassmembers class com.example.untitled1.** {
    public static *;
}

# Prevent obfuscation of method channel method names
-keepclassmembernames class com.example.untitled1.MainActivity {
    public ** showOverlayForLead(...);
    public ** checkOverlayPermission(...);
    public ** requestOverlayPermission(...);
    public ** startCallDetection(...);
    public ** stopCallDetection(...);
    public ** overlayPopUp(...);
}

# ===== ADDITIONAL SAFETY RULES =====
# Keep all classes that extend or implement Android framework classes
-keep class * extends android.content.Context { *; }
-keep class * extends android.app.Service { *; }
-keep class * extends android.content.BroadcastReceiver { *; }

# Keep all constructors
-keepclassmembers class com.example.untitled1.** {
    public <init>(...);
}