package com.security.securx.securx

import android.app.Activity
import android.content.Context
import android.provider.Settings
import io.flutter.plugin.common.MethodCall

class DevModeCheck : SecurityCheck {
    override fun execute(call: MethodCall, context: Context, activity: Activity?): Any? {
        return isDeveloperModeEnabled(context)
    }

    fun isDeveloperModeEnabled(context: Context): Boolean {
        return Settings.Secure.getInt(
                context.contentResolver,
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
        ) != 0
    }


}
