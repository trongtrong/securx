package com.security.securx.securx

import android.os.Build
import java.io.File
import android.util.Log

class EmulatorCheck {

    private val GENY_FILES = arrayListOf(
        "/dev/socket/genyd",
        "/dev/socket/baseband_genyd"
    )

    private val PIPES = arrayListOf(
        "/dev/socket/qemud",
        "/dev/qemu_pipe"
    )

    private val X86_FILES = arrayListOf(
        "ueventd.android_x86.rc",
        "x86.prop",
        "ueventd.ttVM_x86.rc",
        "init.ttVM_x86.rc",
        "fstab.ttVM_x86",
        "fstab.vbox86",
        "init.vbox86.rc",
        "ueventd.vbox86.rc"
    )

    private val ANDY_FILES = arrayListOf(
        "fstab.andy",
        "ueventd.andy.rc"
    )

    private val NOX_FILES = arrayListOf(
        "fstab.nox",
        "init.nox.rc",
        "ueventd.nox.rc"
    )

    fun isEmulator(): Boolean {
        
        return Build.FINGERPRINT.startsWith("generic") ||
                Build.FINGERPRINT.startsWith("unknown") ||
                Build.MODEL.contains("google_sdk") ||
                Build.MODEL.contains("Emulator") ||
                Build.MODEL.contains("Android SDK built for x86") ||
                Build.MANUFACTURER.contains("Genymotion") ||
                Build.MODEL.startsWith("sdk_") ||
                Build.DEVICE.startsWith("emulator") ||
                (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
                Build.PRODUCT == "google_sdk" ||
                // Bluestacks
                (Build.BOARD == "QC_Reference_Phone" && !Build.MANUFACTURER.equals("xiaomi", ignoreCase = true)) ||
                Build.MANUFACTURER.contains("Genymotion") ||
                (Build.HOST.startsWith("Build") && !Build.MANUFACTURER.equals("sony", ignoreCase = true)) ||
                // MSI App Player
                (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) ||
                Build.PRODUCT == "google_sdk" ||
                // Android SDK emulator check
                Build.HARDWARE.contains("goldfish") ||
                Build.HARDWARE.contains("ranchu") ||
                Build.PRODUCT.contains("vbox86p") ||
                Build.PRODUCT.contains("nox", ignoreCase = true) ||
                Build.BOARD.contains("nox", ignoreCase = true) ||
                Build.HARDWARE.contains("nox", ignoreCase = true) ||
                Build.MODEL.contains("droid4x", ignoreCase = true) ||
                Build.HARDWARE == "vbox86" ||
                checkEmulatorFiles()
    }


    private fun checkFiles(targets: List<String>): Boolean {
        for (pipe in targets) {
            val file = File(pipe)
            if (file.exists()) {
                return true
            }
        }
        return false
    }


    private fun checkEmulatorFiles(): Boolean {
        return checkFiles(GENY_FILES) ||
                checkFiles(ANDY_FILES) ||
                checkFiles(NOX_FILES) ||
                checkFiles(X86_FILES) ||
                checkFiles(PIPES)
    }
}