package com.security.securx.securx

import android.os.Debug

class DebuggerProtection {
    fun isDebuggerAttached(): Boolean {
        return Debug.isDebuggerConnected() || Debug.waitingForDebugger();
    }
}