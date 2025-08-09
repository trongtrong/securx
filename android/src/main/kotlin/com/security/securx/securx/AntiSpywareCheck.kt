package com.security.securx.securx

import android.app.Activity
import android.content.Context
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.MethodCall

class AntiSpywareCheck : SecurityCheck {
    override fun execute(call: MethodCall, context: Context, activity: Activity?): Any {
        return isDeviceSafe(call, context, activity)
    }

    fun isDeviceSafe(call: MethodCall, context: Context, activity: Activity?): Boolean {
        return !RootCheck(context).isRooted() &&
                !isDeveloperModeEnabled(context) &&
                !DebuggingModeCheck(context).isDebuggingModeEnabled() &&
                !EmulatorCheck().isEmulator() &&
                !DebuggerProtection().isDebuggerAttached() &&
                !AppCloneChecker(call, activity).appCloneChecker()
    }

    fun isDeveloperModeEnabled(context: Context): Boolean {
        return Settings.Secure.getInt(
                context.contentResolver,
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
        ) != 0
    }

}