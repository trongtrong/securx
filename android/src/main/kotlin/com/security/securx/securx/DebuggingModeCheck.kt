package com.security.securx.securx

import android.content.Context
import android.os.Build
import android.provider.Settings

class DebuggingModeCheck(private val context: Context) {
    fun isDebuggingModeEnabled(): Boolean {
        return isUsbDebuggingModeEnabled() || isAdbDebuggingModeEnabled()
    }

    private fun isUsbDebuggingModeEnabled(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return Settings.Secure.getInt(
                context.contentResolver,
                Settings.Global.ADB_ENABLED, 0
            ) != 0
        } else {
            return false;
        }
    }

    private fun isAdbDebuggingModeEnabled(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return Settings.Secure.getInt(
                context.contentResolver,
                "adb_wifi", 0
            ) != 0
        } else {
            return false;
        }
    }
}