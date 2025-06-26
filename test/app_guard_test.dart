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
