# JNA (Java Native Access) — required by vosk_flutter to bridge to the native Vosk library.
# Without these rules, R8 strips the JNA classes and the app crashes on release builds.
-keep class com.sun.jna.* { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }

# Vosk
-keep class org.vosk.** { *; }

# JNA references java.awt.* (desktop GUI) which doesn't exist on Android.
# These are only used by JNA on desktop — safe to ignore on Android.
-dontwarn java.awt.**
