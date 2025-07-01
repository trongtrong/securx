// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'app_guard_platform_interface.dart';

class AppGuard {
  /// Gets the current platform version.
  ///
  /// Returns a string representing the platform version if successful, otherwise
  /// returns null.
  Future<String?> getPlatformVersion() {
    return AppGuardPlatform.instance.getPlatformVersion();
  }

  /// Checks if the device is Rooted for Android
  /// Checks if the device is Jailbroken for iOS
  /// Returns a boolean indicating whether the device is rooted/jailbroken.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isDeviceRooted() {
    return AppGuardPlatform.instance.isDeviceRooted();
  }

  /// Checks if the device is safe for your app to run on.
  ///
  /// It checks for [isDeviceRooted/jailbroken]  devices,
  /// whether the app is running in [isDebuggingModeEnable],
  /// check whether [isDeveloperModeEnabled]on device,
  /// whether the App is running on [isEmulator],
  /// [isVpnEnabled],
  /// and whether the app is cloned.
  /// Returns a boolean after evaluatng all these scenarios to determine whether the device is safe for your app to run on.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isDeviceSafe() {
    return AppGuardPlatform.instance.isDeviceSafe();
  }

  /// Checks if the device is in debugging mode.
  ///
  /// Returns a boolean indicating whether debugging mode is enabled.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isDebuggingModeEnable() {
    return AppGuardPlatform.instance.isDebuggingModeEnable();
  }

  /// Checks if the device developer mode (Only works on Android)
  ///
  /// Returns a boolean indicating whether developer mode is enabled.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isDeveloperModeEnabled() {
    return AppGuardPlatform.instance.isDeveloperModeEnabled();
  }

  /// Checks if the device is an emulator.
  ///
  /// Returns a boolean indicating whether the device is an emulator.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isEmulator() {
    return AppGuardPlatform.instance.isEmulator();
  }

  /// Checks if a VPN is enabled.
  ///
  /// Returns a boolean indicating whether a VPN is enabled.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isVpnEnabled() {
    return AppGuardPlatform.instance.isVpnEnabled();
  }

  /// Disables the ability to take a screenshot / screenrecording or screen sharing on the device.
  ///
  /// This will set the [WindowManager.LayoutParams.FLAG_SECURE] flag on the
  /// current activity, which will prevent the device from taking a screenshot.
  ///
  /// It uses [ScreenProtectorKit] to disable the screenshot on iOS
  ///
  /// Note that this is a best effort and may not work on all devices or platforms.
  Future<void> disableScreenshot() {
    return AppGuardPlatform.instance.disableScreenshot();
  }

  /// Allows to takes screenshots / screenrecording or screen sharing
  ///
  /// This will clear [WindowManager.LayoutParams.FLAG_SECURE] flag on the
  /// current activity, which will allow the device to take screenshot/ screenrecording or screen sharing.
  ///
  /// It uses [ScreenProtectorKit] to enable the screenshot on iOS
  ///
  /// Note that this is a best effort and may not work on all devices or platforms.
  Future<void> enableScreenshot() {
    return AppGuardPlatform.instance.enableScreenshot();
  }

  /// Checks if the device has a debugger attached.
  ///
  /// Returns a boolean indicating whether the device has a debugger attached.
  /// If the platform does not support this operation, it returns null.
  Future<bool?> isDebuggerAttached() {
    return AppGuardPlatform.instance.isDebuggerAttached();
  }

  /// Checks if the app is cloned. (Only works on Android)
  ///
  /// This function evaluates whether the application is running as a cloned app
  /// by using the provided application ID.
  ///
  /// Returns a boolean indicating whether the app is cloned. If the platform does
  /// not support this operation, it returns null.
  Future<bool?> isAppCloned({required String applicationID}) {
    return AppGuardPlatform.instance.isAppCloned(applicationID);
  }
}
