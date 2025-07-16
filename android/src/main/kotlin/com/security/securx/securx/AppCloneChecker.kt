package com.security.securx.securx

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall

class AppCloneChecker(private val call: MethodCall, private val myActivity: Activity?) {

    private val dualAppId999 = "999"

    fun appCloneChecker(): Boolean {
        Log.d("AppCloneCheckerPlugin", "Executing App clone Checker")
//        val resultMap = mutableMapOf<String, String>()

        var isValidApp = true
        val applicationID = call.argument<String>("applicationID") ?: ""

//        val workProfileAllowedFlag: Boolean =
//            call.argument<Boolean>("isWorkProfileAllowed") ?: true

        if (applicationID.isBlank() || applicationID.isEmpty()) {
            isValidApp = true
        }

        myActivity?.let {

            val path: String = it.filesDir.path
            //This will detect if app is accessed through Work Profile
            val devicePolicyManager =
                myActivity.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val activeAdmins: List<ComponentName>? = devicePolicyManager.activeAdmins
            val appPackageDotCount = applicationID.count { it == '.' }

            if (getDotCount(path, appPackageDotCount) > appPackageDotCount) {
                ///"Package Mismatch"
                ///"Cloned App"
                isValidApp = false
                Log.d("AppCloneCheckerPlugin", "Package ID Mismatch")

            } else if (path.contains(dualAppId999)) {
                ///"Package Directory Mismatch"
                ///"Cloned App"
                Log.d("AppCloneCheckerPlugin", "Directory $path")
                isValidApp = false
                Log.d("AppCloneCheckerPlugin", "Package Mismatch")

            } else if (activeAdmins != null) {
                ///"Used through Work Profile"
                ///"Cloned App"
                val gmsPackages =
                    activeAdmins.filter { filter -> filter.packageName == "com.google.android.gms" }
                val samsungDevice =
                    activeAdmins.any { filter -> filter.packageName.contains("com.samsung") }

                if (samsungDevice) {
                    activeAdmins.forEach { admin ->

                        if (devicePolicyManager.isProfileOwnerApp(admin.packageName)) {
                            isValidApp = false
                        }

                    }
                } else
                    if (gmsPackages.size != activeAdmins.size) {
                        Log.d("AppCloneCheckerPlugin", "Work Mode")
                        isValidApp = false

                    } else {

                    }
            } else {

            }
        }

        return !isValidApp
    }
}

private fun getDotCount(path: String, appPackageDotCount: Int): Int {
    var count = 0
    for (element in path) {
        if (count > appPackageDotCount) {
            break
        }
        if (element == '.') {
            count++
        }
    }
    return count
}