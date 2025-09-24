# Flutter
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Firebase & Google
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Your app
-keep class com.smartshop.** { *; }

# Firestore & gRPC
-keep class io.grpc.** { *; }
-keep class com.google.protobuf.** { *; }

# Image Picker
-keep class com.imagepicker.** { *; }

# Networking
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# UUID & Crypto
-keep class java.util.UUID { *; }
-keep class org.spongycastle.** { *; }

# Parcelable, Serializable, Enums
-keepclassmembers class * implements android.os.Parcelable { public static final android.os.Parcelable$Creator *; }
-keepnames class * implements java.io.Serializable
-keepclassmembers enum * { public static **[] values(); public static ** valueOf(java.lang.String); }

# Keep annotations
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * { @androidx.annotation.Keep <fields>; @androidx.annotation.Keep <methods>; }
# Keep Flutter split compatibility
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# Keep gRPC and OkHttp
-keep class io.grpc.** { *; }
-dontwarn io.grpc.**
-keep class com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

# Keep generated classes
-keep class io.flutter.embedding.engine.** { *; }
