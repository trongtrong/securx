package com.security.securx.securx

import android.app.Activity
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SexurxPlugin */
// Implement ActivityAware to get access to the Activity
class SecurxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null
    private var activity: Activity? = null

    val securityChecks: Map<String, SecurityCheck> = mapOf(
            "as" to AntiSpywareCheck(),
            "or" to RootDetectionCheck(),
            "md" to DevModeCheck(),
            "mdg" to DebuggingModeCheckCmd(),
            "ei" to EmulatorDetectionCheck(),
            "dea" to DebuggerAttachedCheck(),
            "ac" to AppCloneDetectionCheck()
    )

    // Called when the plugin is first attached to a FlutterEngine.
    // Provides the application context.
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "go")
        channel.setMethodCallHandler(this)
    }

    // Handles method calls from Flutter.
    override fun onMethodCall(call: MethodCall, result: Result) {
        // Ensure context is available before proceeding with calls that need it
        val currentContext = applicationContext
        if (currentContext == null) {
            result.error("UNAVAILABLE", "Plugin not attached to context.", null)
            return
        }

        val check = securityChecks[call.method]
        if (check != null) {
            try {
                val output = check.execute(call, currentContext, activity)
                result.success(output)
            } catch (e: Exception) {
                result.error("error", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        applicationContext = null // Clear context reference
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null // Clear activity reference
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null // Clear activity reference
    }
}
