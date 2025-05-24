# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.hiennv.flutter_callkit_incoming.** { *; }


# VoIP24h SDK
-keep class voip24h.sdk.mobile.voip24h_sdk_mobile.** { *; }


# Your SIP-related classes
#-keep class com.example.untitled1.SIPConfiguration { *; }
#-keep class com.example.untitled1.SIPCredential { *; }
#-keep class com.example.untitled1.SipAccountStatus { *; }

# If you're using any external libraries for SIP, add rules for them here

# Preserve all native method names and the names of their classes.
-keepclasseswithmembernames class * {
    native <methods>;
}


# Preserve all classes that have special context
#-keep public class * extends android.app.Activity
#-keep public class * extends android.app.Application
#-keep public class * extends android.app.Service
#-keep public class * extends android.content.BroadcastReceiver
#-keep public class * extends android.content.ContentProvider
#-keep public class * extends android.app.backup.BackupAgentHelper
#-keep public class * extends android.preference.Preference

# Preserve all View implementations, their special context constructors, and
# their setters.
#-keep public class * extends android.view.View {
#    public <init>(android.content.Context);
#    public <init>(android.content.Context, android.util.AttributeSet);
#    public <init>(android.content.Context, android.util.AttributeSet, int);
#    public void set*(...);
#}

# Preserve Parcelables
#-keep class * implements android.os.Parcelable {
#  public static final android.os.Parcelable$Creator *;
#}

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
#    public static ** valueOf(java.lang.String);
}