package com.security.securx.securx
import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall

class RootDetectionCheck : SecurityCheck {
    override fun execute(call: MethodCall, context: Context, activity: Activity?): Any {
        return RootCheck(context).isRooted()
    }
}