import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'securx_constant.dart';

import 'securx_platform_interface.dart';

/// An implementation of [SecurxPlatform] that uses method channels.
class MethodChannelSecurx extends SecurxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('go');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> isDeviceRooted() async {
    final rooted = await methodChannel.invokeMethod<bool>('or');
    return rooted;
  }

  @override
  Future<bool?> isDeviceSafe() async {
    final safe = await methodChannel.invokeMethod<bool>('as');
    return safe;
  }

  @override
  Future<bool?> isDebuggingModeEnable() async {
    final usbDebug = await methodChannel.invokeMethod<bool>('mdg');
    return usbDebug;
  }

  @override
  Future<bool?> isDeveloperModeEnabled() async {
    final developerMode = await methodChannel.invokeMethod<bool>('md');
    return developerMode;
  }

  @override
  Future<bool?> isEmulator() async {
    final emulator = await methodChannel.invokeMethod<bool>('ei');
    return emulator;
  }

  @override
  Future<bool?> isVpnEnabled() async {
    try {
      final interfaces = await NetworkInterface.list();

      return interfaces.any((interface) {
        return commonVpnInterfaceNamePatterns.any((pattern) {
          if (Platform.isIOS &&
              (interface.name.toLowerCase().contains('ipsec') ||
                  interface.name.toLowerCase().contains('utun6') ||
                  interface.name.toLowerCase().contains('ikev2') ||
                  interface.name.toLowerCase().contains('l2tp'))) {
            return false;
          }
          return interface.name.toLowerCase().contains(pattern);
        });
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disableScreenshot() async {
    await methodChannel.invokeMethod<void>('disableScreenshot');
  }

  @override
  Future<void> enableScreenshot() async {
    await methodChannel.invokeMethod<void>('enableScreenshot');
  }

  @override
  Future<bool?> isDebuggerAttached() async {
    final rooted = await methodChannel.invokeMethod<bool>('dea');
    return rooted;
  }

  @override
  Future<bool?> isAppCloned({required String applicationID}) async {
    // Pass the applicationID to the native side.
    final isCloned = await methodChannel.invokeMethod<bool>('ac', {
      'applicationID': applicationID,
    });
    return isCloned;
  }
}
