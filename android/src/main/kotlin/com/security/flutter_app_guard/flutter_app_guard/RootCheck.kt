package com.security.flutter_app_guard.flutter_app_guard

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import java.io.BufferedReader
import java.io.File
import java.io.FileInputStream
import java.io.InputStreamReader

class RootCheck(private val context: Context) {

    private val blackListedMountPaths = arrayOf(
        "magisk",
        "core/mirror",
        "core/img"
    )

    private val suPaths = arrayOf(
        "/system/app/Superuser.apk", "/sbin/su", "/system/bin/su", "/system/xbin/su",
        "/data/local/xbin/su", "/data/local/bin/su", "/system/sd/xbin/su", "/system/bin/failsafe/su",
        "/data/local/su", "/su/bin/su", "/system/bin/.ext/su", "/system/usr/we-need-root/su", "/cache/su",
        "/data/su", "/dev/su"
    )

    private val knownRootAppsPackages = arrayOf(
        "com.noshufou.android.su",
        "com.noshufou.android.su.elite",
        "eu.chainfire.supersu",
        "com.koushikdutta.superuser",
        "com.thirdparty.superuser",
        "com.yellowes.su",
        "com.topjohnwu.magisk",
        "com.kingroot.kinguser",
        "com.kingo.root",
        "com.smedialink.oneclickroot",
        "com.zhiqupk.root.global",
        "com.alephzain.framaroot"
    )

    private val knownDangerousAppsPackages = arrayOf(
        "com.koushikdutta.rommanager",
        "com.koushikdutta.rommanager.license",
        "com.dimonvideo.luckypatcher",
        "com.chelpus.lackypatch",
        "com.ramdroid.appquarantine",
        "com.ramdroid.appquarantinepro",
        "com.android.vending.billing.InAppBillingService.COIN",
        "com.android.vending.billing.InAppBillingService.LUCK",
        "com.chelpus.luckypatcher",
        "com.blackmartalpha",
        "org.blackmart.market",
        "com.allinone.free",
        "com.repodroid.app",
        "org.creeplays.hack",
        "com.baseappfull.fwd",
        "com.zmapp",
        "com.dv.marketmod.installer",
        "org.mobilism.android",
        "com.android.wp.net.log",
        "com.android.camera.update",
        "cc.madkite.freedom",
        "com.solohsu.android.edxp.manager",
        "org.meowcat.edxposed.manager",
        "com.xmodgame",
        "com.cih.game_cih",
        "com.charles.lpoqasert",
        "catch_.me_.if_.you_.can_"
    )

    private val knownRootCloakingPackages = arrayOf(
        "com.devadvance.rootcloak",
        "com.devadvance.rootcloakplus",
        "de.robv.android.xposed.installer",
        "com.saurik.substrate",
        "com.zachspong.temprootremovejb",
        "com.amphoras.hidemyroot",
        "com.amphoras.hidemyrootadfree",
        "com.formyhm.hiderootPremium",
        "com.formyhm.hideroot"
    )


    fun isRooted(): Boolean {
        return isDeviceInTestMode() || doesDeviceHasSu()
                || checksForRootAccessUsingSu() || isMagiskPresent()
                || detectRootManagementApps() || detectDangerousApps()
                || detectRootCloakingApps()
    }

    private fun isDeviceInTestMode(): Boolean {
        return Build.TAGS?.contains("test-keys") == true
    }

    private fun doesDeviceHasSu(): Boolean {
        return suPaths.any { File(it).exists() }
    }

    private fun checksForRootAccessUsingSu(): Boolean {
        var process: Process? = null
        return try {
            process = Runtime.getRuntime().exec(arrayOf("su", "-c", "ls", "/system/xbin/which"))
            val os = java.io.DataOutputStream(process.outputStream)
            os.writeBytes("exit\n")
            os.flush()
            val exitValue = process.waitFor()
            exitValue == 0
        } catch (e: Exception) {
            false
        } finally {
            process?.destroy()
        }
    }

    private fun isMagiskPresent(): Boolean {
        val file = File("/proc/self/mounts")
        return try {
            FileInputStream(file).use { fis ->
                BufferedReader(InputStreamReader(fis)).use { reader ->
                    var line: String?
                    while (reader.readLine().also { line = it } != null) {
                        if (blackListedMountPaths.any { path -> line!!.contains(path) }) {
                            return true
                        }
                    }
                    false
                }
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun detectRootManagementApps(): Boolean {
        val packages = ArrayList(knownRootAppsPackages.toList())
        return isAnyPackageFromListInstalled(packages)
    }

    private fun detectDangerousApps(): Boolean {
        val packages = ArrayList(knownDangerousAppsPackages.toList())
        return isAnyPackageFromListInstalled(packages)
    }

    private fun detectRootCloakingApps(): Boolean {
        val packages = ArrayList(knownRootCloakingPackages.toList())
        return isAnyPackageFromListInstalled(packages)
    }

    private fun isAnyPackageFromListInstalled(packages: List<String>): Boolean {
        val pm = context.packageManager

        for (packageName in packages) {
            try {
                pm.getPackageInfo(packageName, 0)
                return true
            } catch (e: PackageManager.NameNotFoundException) {
                return false
            }
        }

        return false
    }

}