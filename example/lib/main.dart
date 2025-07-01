import 'dart:async';

import 'package:app_guard/app_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isDeviceSafe = false,
      _isDebuggingModeEnable = false,
      _isDeveloperModeEnabled = false,
      _isVpnEnabled = false,
      _isScreenshotDisabled = false,
      _isDebuggerAttached = false,
      _copyPasteEnable = false,
      _isAppCloned = false;
  bool? _isDeviceRooted, _isEmulator;

  final _appGuardPlugin = AppGuard();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isDeviceSafe, isDebuggingModeEnable, isDeveloperModeEnabled, isVpnEnabled;
    bool? isDeviceRooted, isEmulator;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _appGuardPlugin.getPlatformVersion() ?? 'Unknown platform version';
      isDeviceRooted = await _appGuardPlugin.isDeviceRooted();
      isDeviceSafe = await _appGuardPlugin.isDeviceSafe() ?? false;
      isDebuggingModeEnable = await _appGuardPlugin.isDebuggingModeEnable() ?? false;
      isDeveloperModeEnabled = await _appGuardPlugin.isDeveloperModeEnabled() ?? false;
      isEmulator = await _appGuardPlugin.isEmulator();
      isVpnEnabled = await _appGuardPlugin.isVpnEnabled() ?? false;
      _isDebuggerAttached = await _appGuardPlugin.isDebuggerAttached() ?? false;
      //TODO ask for application ID in case if app clone needs to be checked
      _isAppCloned =
          await _appGuardPlugin.isAppCloned(applicationID: "com.security.app_guard") ?? false;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      isDeviceRooted = false;
      isDeviceSafe = true;
      isDebuggingModeEnable = false;
      isDeveloperModeEnabled = false;
      isEmulator = false;
      isVpnEnabled = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isDeviceRooted = isDeviceRooted;
      _isDeviceSafe = isDeviceSafe;
      _isDebuggingModeEnable = isDebuggingModeEnable;
      _isDeveloperModeEnabled = isDeveloperModeEnabled;
      _isEmulator = isEmulator;
      _isVpnEnabled = isVpnEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('App Guards Plugin')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Running on: $_platformVersion\n'),
                Text('Is Device Safe: $_isDeviceSafe\n'),
                const Divider(),
                const Text('Checklist', textAlign: TextAlign.center),
                const Divider(),
                Text('Is Device Rooted: ${_isDeviceRooted ?? "Unknown"}'),
                Text('Is Debugging Mode Enable: $_isDebuggingModeEnable'),
                Text('Is Developer Mode Enabled: $_isDeveloperModeEnabled'),
                Text('Is Emulator: ${_isEmulator ?? "Unknown"}'),
                Text('Is VPN Enabled: $_isVpnEnabled'),
                Text('Is Screenshot Disabled: $_isScreenshotDisabled'),
                Text('Is Debugger Attached: $_isDebuggerAttached'),
                Text('Is App Cloned: $_isAppCloned'),
                Text('Is Copy paste Enabled: $_copyPasteEnable'),
                const Divider(),
                ListTile(
                  title: const Text("Copy Paste"),
                  subtitle: _copyPasteEnable ? const Text("Enabled") : const Text("Disabled"),
                  trailing: Switch.adaptive(
                    value: _copyPasteEnable,
                    onChanged: (value) {
                      _copyPasteEnable = !_copyPasteEnable;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text("TextField"),
                      border: OutlineInputBorder(),
                    ),
                    enableInteractiveSelection: _copyPasteEnable,
                    contextMenuBuilder: _copyPasteEnable
                        ? (context, editableTextState) {
                            final buttonItems = editableTextState.contextMenuButtonItems;
                            return AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: editableTextState.contextMenuAnchors,
                              buttonItems: buttonItems,
                            );
                          }
                        : null,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("TextFormField"),
                      border: OutlineInputBorder(),
                    ),
                    enableInteractiveSelection: _copyPasteEnable,
                    contextMenuBuilder: _copyPasteEnable
                        ? (context, editableTextState) {
                            final buttonItems = editableTextState.contextMenuButtonItems;
                            return AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: editableTextState.contextMenuAnchors,
                              buttonItems: buttonItems,
                            );
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Screen Capturing and Screensharing"),
                  subtitle: !_isScreenshotDisabled
                      ? const Text("Allowed")
                      : const Text("Restricted"),
                  trailing: Switch.adaptive(
                    value: !_isScreenshotDisabled,
                    onChanged: (value) {
                      if (_isScreenshotDisabled) {
                        _appGuardPlugin.enableScreenshot();
                      } else {
                        _appGuardPlugin.disableScreenshot();
                      }
                      _isScreenshotDisabled = !_isScreenshotDisabled;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
