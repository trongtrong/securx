package com.security.securx.securx

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall

class AppCloneDetectionCheck : SecurityCheck {
    override fun execute(call: MethodCall, context: Context, activity: Activity?): Any {
        if (activity != null) {
            return AppCloneChecker(call, activity).appCloneChecker()
        }
        throw IllegalStateException("error")
    }
}