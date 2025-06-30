import java.util.Properties // Añadimos el import explícito

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sena_gestion_carnets"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sena_gestion_carnets"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Carga las propiedades del keystore desde key.properties con depuración
    val keystoreProperties = Properties().apply {
        val keystorePropertiesFile = file("../key.properties") // Ajuste a la carpeta android/
        println("Checking keystore file: ${keystorePropertiesFile.absolutePath}") // Depuración
        if (keystorePropertiesFile.exists()) {
            load(keystorePropertiesFile.inputStream())
            println("Loaded properties: $this") // Depuración
        } else {
            println("Keystore file does not exist!")
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: throw IllegalStateException("keyAlias is missing in key.properties")
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: throw IllegalStateException("keyPassword is missing in key.properties")
            storeFile = file(keystoreProperties.getProperty("storeFile") ?: throw IllegalStateException("storeFile is missing in key.properties"))
            storePassword = keystoreProperties.getProperty("storePassword") ?: throw IllegalStateException("storePassword is missing in key.properties")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}