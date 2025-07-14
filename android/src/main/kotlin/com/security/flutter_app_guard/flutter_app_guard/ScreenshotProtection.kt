package com.security.flutter_app_guard.flutter_app_guard

import android.app.Activity
import android.view.WindowManager

class ScreenshotProtection(private val activity: Activity?){

    fun turnScreenshotOn(): Boolean {
        activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        return true
    }

    fun turnScreenshotOff(): Boolean {
        activity?.window?.setFlags(
          WindowManager.LayoutParams.FLAG_SECURE,
          WindowManager.LayoutParams.FLAG_SECURE
        )
        return true
    }

}