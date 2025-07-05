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
  Future<void> disableScreenshot() async {
    // Simulate successful call
    return;
  }

  @override
  Future<void> enableScreenshot() async {
    // Simulate successful call
    return;
  }

  @override
  Future<bool?> isDeviceRooted() async => false;

  @override
  Future<bool?> isDeviceSafe() async => true;

  @override
  Future<bool?> isDebuggingModeEnable() async => false;

  @override
  Future<bool?> isDeveloperModeEnabled() async => false;

  @override
  Future<bool?> isEmulator() async => false;

  @override
  Future<bool?> isVpnEnabled() async => true;

  @override
  Future<bool?> isDebuggerAttached() async => false;

  @override
  Future<bool?> isAppCloned({required String applicationID}) async => false;
}


void main() {
  final AppGuardPlatform initialPlatform = AppGuardPlatform.instance;

  test('$MethodChannelAppGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppGuard>());
  });

  setUp(() {
    AppGuardPlatform.instance = MockAppGuardPlatform();
  });

  test('getPlatformVersion', () async {
    AppGuard appGuardPlugin = AppGuard(
      applicationID: 'com.security.app_guard',
    );
    expect(await appGuardPlugin.getPlatformVersion, '42');
  });

  test('isDeviceRooted returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isDeviceRooted, false);
  });

  test('isDeviceSafe returns true', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isDeviceSafe, true);
  });

  test('isDebuggingModeEnabled returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isDebuggingModeEnabled, false);
  });

  test('isDeveloperModeEnabled returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isDeveloperModeEnabled, false);
  });

  test('isEmulator returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isEmulator, false);
  });

  test('isVpnEnabled returns true', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isVpnEnabled, true);
  });

  test('isDebuggerAttached returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isDebuggerAttached, false);
  });

  test('isAppCloned returns false', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    expect(await appGuardPlugin.isAppCloned, false);
  });

  test('setScreenshotProtection does not throw', () async {
    AppGuard appGuardPlugin = AppGuard(applicationID: 'com.security.app_guard');
    await appGuardPlugin.setScreenshotProtection(enabled: true);
    await appGuardPlugin.setScreenshotProtection(enabled: false);
    expect(true, isTrue);
  });
}

