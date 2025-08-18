package com.fitsy.fitsy

import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(b: Bundle?) {
        installSplashScreen()
        super.onCreate(b)
    }
}
