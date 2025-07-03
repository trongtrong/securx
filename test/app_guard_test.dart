import 'package:flutter_test/flutter_test.dart';
import 'package:app_guard/app_guard.dart';
import 'package:app_guard/app_guard_platform_interface.dart';
import 'package:app_guard/app_guard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppGuardPlatform
    with MockPlatformInterfaceMixin
    implements AppGuardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> disableScreenshot() {
    // TODO: implement disableScreenshot
    throw UnimplementedError();
  }

  @override
  Future<void> enableScreenshot() {
    // TODO: implement enableScreenshot
    throw UnimplementedError();
  }

  @override
  Future<bool?> isAppCloned(String applicationID) {
    // TODO: implement isAppCloned
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDebuggerAttached() {
    // TODO: implement isDebuggerAttached
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDebuggingModeEnable() {
    // TODO: implement isDebuggingModeEnable
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDeveloperModeEnabled() {
    // TODO: implement isDeveloperModeEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDeviceRooted() {
    // TODO: implement isDeviceRooted
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDeviceSafe() {
    // TODO: implement isDeviceSafe
    throw UnimplementedError();
  }

  @override
  Future<bool?> isEmulator() {
    // TODO: implement isEmulator
    throw UnimplementedError();
  }

  @override
  Future<bool?> isVpnEnabled() {
    // TODO: implement isVpnEnabled
    throw UnimplementedError();
  }
}

void main() {
  final AppGuardPlatform initialPlatform = AppGuardPlatform.instance;

  test('$MethodChannelAppGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppGuard>());
  });

  test('getPlatformVersion', () async {
    AppGuard appGuardPlugin = AppGuard();
    MockAppGuardPlatform fakePlatform = MockAppGuardPlatform();
    AppGuardPlatform.instance = fakePlatform;

    expect(await appGuardPlugin.getPlatformVersion(), '42');
  });
}
