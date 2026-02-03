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
    namespace = "com.technoava.astra"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    defaultConfig {
        applicationId = "com.technoava.astra"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

// Workaround for Flutter CLI not finding APK with AGP 8.9.x
// See: https://github.com/flutter/flutter/issues/174620
val flutterOutDir = file("$buildDir/outputs/flutter-apk")
val cliOutDir = file("${rootDir.parentFile}/build/app/outputs/flutter-apk")

tasks.register<Copy>("syncFlutterApks") {
    from(flutterOutDir)
    into(cliOutDir)
    doFirst {
        cliOutDir.mkdirs()
    }
}

android.applicationVariants.all {
    val variantName = name.replaceFirstChar { it.uppercase() }
    listOf("package$variantName", "assemble$variantName").forEach { taskName ->
        tasks.matching { it.name == taskName }.configureEach {
            finalizedBy(tasks.named("syncFlutterApks"))
        }
    }
}
