import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_guard_platform_interface.dart';

/// An implementation of [AppGuardPlatform] that uses method channels.
class MethodChannelAppGuard extends AppGuardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_guard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
