## Core Flutter framework: keep entry points used via reflection
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.Log { *; }

## GetX + dependency injection helpers
-keep class get.** { *; }
-keep class com.github.andriydruk.** { *; }

## Speech + Google services bridges
-keep class com.tundralabs.fluttertts.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

## Kotlin metadata
-keep class kotlin.Metadata { *; }

## Silence benign warnings
-dontwarn javax.annotation.**
-dontwarn sun.misc.**
-dontwarn java.nio.file.Files

## Trim stack traces for smaller APKs
-optimizations !code/simplification/arithmetic,!code/allocation/variable

