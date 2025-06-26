import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_guard_method_channel.dart';

abstract class AppGuardPlatform extends PlatformInterface {
  /// Constructs a AppGuardPlatform.
  AppGuardPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppGuardPlatform _instance = MethodChannelAppGuard();

  /// The default instance of [AppGuardPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppGuard].
  static AppGuardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppGuardPlatform] when
  /// they register themselves.
  static set instance(AppGuardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
