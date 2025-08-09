package com.security.securx.securx

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall

interface SecurityCheck {
    fun execute(call: MethodCall, context: Context, activity: Activity?): Any?
}