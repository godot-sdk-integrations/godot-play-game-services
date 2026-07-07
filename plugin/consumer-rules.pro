# =============================================
# Godot Play Game Services
# =============================================

# Godot Plugin classes
-keep class com.jacobibanez.plugin.android.godotplaygameservices.** { *; }
-keepclassmembers class com.jacobibanez.plugin.android.godotplaygameservices.** { *; }

# Godot engine reflection / JNI
-keep class org.godotengine.godot.** { *; }
-keep class com.godot.** { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    *;
}

# Play Games Services v2
-keep class com.google.android.gms.games.** { *; }
-keep class com.google.android.gms.games.internal.** { *; }
-keep class com.google.android.gms.auth.** { *; }

# Save callback-s and inner classes, that Google uses through reflection
-keepclassmembers class com.google.android.gms.games.** {
    public protected *;
}

# Gson
-keep class com.google.gson.** { *; }
-keepclassmembers class * implements com.google.gson.TypeAdapterFactory { *; }
-keepclassmembers class * implements com.google.gson.JsonSerializer { *; }
-keepclassmembers class * implements com.google.gson.JsonDeserializer { *; }

# 5. General Android libraries + Google Play Services
-dontwarn com.google.android.gms.**
-dontwarn org.godotengine.**
