package com.security.app_guard.app_guard

import android.net.wifi.WifiManager
import android.content.Context
import android.util.Log

class WifiSecured(private val context: Context) {
    
    fun isWifiSecured(): String {
        try {
            val wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            Log.v("Wifi","${wifiManager.isWifiEnabled}")
            val currentNetwork = wifiManager.connectionInfo
            val scanResults = wifiManager.scanResults
            for (result in scanResults) {
                Log.v("WiFiScan", "SSID: ${result.SSID}, BSSID: ${result.BSSID}, Capabilities: ${result.capabilities}, Frequency: ${result.frequency}, Level: ${result.level}")
            }
            Log.v("WifiSize", "Size: ${scanResults.size}")
            val currentSSID = currentNetwork.ssid
            Log.v("TAG", currentSSID)
            val security = scanResults.find { it.SSID == currentSSID }?.capabilities ?: "Unknown"
            return security
        } catch (e: Exception) {
            return e.toString()
        }
    }
}