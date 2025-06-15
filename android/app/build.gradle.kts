plugins {
    id("com.android.application")
    id("kotlin-android")
    // Le plugin Flutter doit venir après les plugins Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.teste1"
    compileSdk = flutter.compileSdkVersion

    // Correction : override de la version du NDK requise
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.example.teste1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Pour l’instant on signe avec les clés debug
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}