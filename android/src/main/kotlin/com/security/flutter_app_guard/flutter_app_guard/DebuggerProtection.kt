package com.security.flutter_app_guard.flutter_app_guard

import android.os.Debug

class DebuggerProtection {
    fun isDebuggerAttached(): Boolean {
        return Debug.isDebuggerConnected() || Debug.waitingForDebugger();
    }
}