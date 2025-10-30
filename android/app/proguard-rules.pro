# Flutter & Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Kotlin metadata
-keepclassmembers class **$WhenMappings { *; }

# Prevent issues with reflection
-keepattributes *Annotation*
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep entry points used by Flutter
-keep public class * extends io.flutter.embedding.android.FlutterActivity
-keep public class * extends io.flutter.embedding.engine.FlutterEngine
-keep public class * extends io.flutter.app.FlutterApplication

# Remove logging and debugging
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Optimize aggressively
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
