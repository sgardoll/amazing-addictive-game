import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.connectio.mindsweeper"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.connectio.mindsweeper"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue(
            "string",
            "google_play_rsa_public_key",
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8r0Cvpr++JXBx4TAXEhSoHg8H9u+0tVhwZIukpYPNZeKuBPxRSEeYeAOfKkpTuZKHUiunBQn/nY2DCqTorSu63gXDGEA94N4VyQ6ZAwM8FUHut8maGiJQl/q7RFT98xwihyngByCwz0DpYVt9WzXHBrX/jSiMPBZIDG+PR+wDdFMym/7MZ1oUS+96uF9BlQlvl5r7Zy6RC1O1H1MXe4PrpfBjIA8tVH5dxZS6sVBwuqYxBpEadX0Zo4Aloxz4CxGsuhLj59TghChd3pnMje51Bkdu5EW3Y84JWK9xQyC+EylEUoAyac8f+h9w559aAt/Ax8E8mMHPvQk0AxzjI1wZwIDAQAB",
        )
    }

    signingConfigs {
        create("release") {
            keyAlias = System.getenv("ANDROID_KEY_ALIAS") ?: keystoreProperties["keyAlias"] as String?
            keyPassword = System.getenv("ANDROID_KEY_PASSWORD") ?: keystoreProperties["keyPassword"] as String?
            
            val storeFilePath = System.getenv("ANDROID_KEYSTORE_PATH") ?: keystoreProperties["storeFile"] as String?
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            storePassword = System.getenv("ANDROID_STORE_PASSWORD") ?: keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            val releaseConfig = signingConfigs.getByName("release")
            if (releaseConfig.keyAlias != null && releaseConfig.keyPassword != null && releaseConfig.storeFile?.exists() == true && releaseConfig.storePassword != null) {
                signingConfig = releaseConfig
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
