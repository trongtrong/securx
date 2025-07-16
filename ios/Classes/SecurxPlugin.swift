import Flutter
import UIKit
import DTTJailbreakDetection
import ScreenProtectorKit

public class SecurxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "securx", binaryMessenger: registrar.messenger())
    let instance = SecurxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let window = UIApplication.shared.windows.first
        let screenProtectorKit = ScreenProtectorKit(window: window)
        screenProtectorKit.configurePreventionScreenshot()
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "isDeviceRooted":
            result(isJailBroken())
        case "isDeviceSafe":
            result(isDeviceSafe())
        case "isDebuggingModeEnable":
            result(false)
        case "isDeveloperModeEnabled":
            result(false)
        case "isEmulator":
            result(isSimulator())
        case "enableScreenshot":
            screenProtectorKit.disablePreventScreenshot()
            result(true)
        case "disableScreenshot":
            screenProtectorKit.enabledPreventScreenshot()
            result(true) // no need to return anything
        case "isDebuggerAttached":
            result(isDebuggerAttached)
        case "isAppCloned":
            result(false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func isDeviceSafe() -> Bool {
        return !isJailBroken()
                && !isDebuggerAttached
                && !isSimulator()
                // !isDeveloperModeEnabled()
    }
    
    private func isSimulator() -> Bool {
    #if targetEnvironment(simulator)
        return true
    #else
        return false
    #endif
    }
    
    private func isJailBroken() -> Bool {
        return DTTJailbreakDetection.isJailbroken()
    }
    
    let isDebuggerAttached: Bool = {
        var debuggerIsAttached = false
    
        var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info: kinfo_proc = kinfo_proc()
        var info_size = MemoryLayout<kinfo_proc>.size
    
        let success = name.withUnsafeMutableBytes { (nameBytePtr: UnsafeMutableRawBufferPointer) -> Bool in
            guard let nameBytesBlindMemory = nameBytePtr.bindMemory(to: Int32.self).baseAddress else { return false }
            return -1 != sysctl(nameBytesBlindMemory, 4, &info, &info_size, nil, 0)
        }
    
        if !success {
            debuggerIsAttached = false
        }
    
        if !debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0 {
            debuggerIsAttached = true
        }
    
        return debuggerIsAttached
    }()
}
