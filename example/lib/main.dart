import 'package:app_guard/app_guard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool 
      _isScreenshotDisabled = false,
      _copyPasteEnable = true;

  // State variables for async values
  String? _platformVersion;
  bool? _isDeviceSafe;
  bool? _isDeviceRooted;
  bool? _isDebuggingModeEnabled;
  bool? _isDeveloperModeEnabled;
  bool? _isEmulator;
  bool? _isVpnEnabled;
  bool? _isDebuggerAttached;
  bool? _isAppCloned;

  final _appGuardPlugin = AppGuard(
    applicationID: "com.security.app_guard",
    initialClipboardProtection: true,
    initialScreenshotProtection: false
  );

  @override
  void initState() {
    super.initState();
    _fetchDeviceSecurityInfo();
    _appGuardPlugin.isClipboardProtected.addListener(() {
      setState(() {
        _copyPasteEnable = !_appGuardPlugin.isClipboardProtected.value;
      });
    });
  }

  Future<void> _fetchDeviceSecurityInfo() async {
    final platformVersion = await _appGuardPlugin.getPlatformVersion;
    final isDeviceSafe = await _appGuardPlugin.isDeviceSafe;
    final isDeviceRooted = await _appGuardPlugin.isDeviceRooted;
    final isDebuggingModeEnabled = await _appGuardPlugin.isDebuggingModeEnabled;
    final isDeveloperModeEnabled = await _appGuardPlugin.isDeveloperModeEnabled;
    final isEmulator = await _appGuardPlugin.isEmulator;
    final isVpnEnabled = await _appGuardPlugin.isVpnEnabled;
    final isDebuggerAttached = await _appGuardPlugin.isDebuggerAttached;
    final isAppCloned = await _appGuardPlugin.isAppCloned;

    setState(() {
      _platformVersion = platformVersion;
      _isDeviceSafe = isDeviceSafe;
      _isDeviceRooted = isDeviceRooted;
      _isDebuggingModeEnabled = isDebuggingModeEnabled;
      _isDeveloperModeEnabled = isDeveloperModeEnabled;
      _isEmulator = isEmulator;
      _isVpnEnabled = isVpnEnabled;
      _isDebuggerAttached = isDebuggerAttached;
      _isAppCloned = isAppCloned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('App Guard Plugin')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Running on: ${_platformVersion ?? "loading..."}'),
                Text('Is Device Safe: ${_isDeviceSafe ?? "loading..."}'),
                const Divider(),
                const Text('Checklist', textAlign: TextAlign.center),
                const Divider(),
                Text('Is Device Rooted: ${_isDeviceRooted ?? "loading..."}'),
                Text('Is Debugging Mode Enable: ${_isDebuggingModeEnabled ?? "loading..."}'),
                Text('Is Developer Mode Enabled: ${_isDeveloperModeEnabled ?? "loading..."}'),
                Text('Is Emulator: ${_isEmulator ?? "loading..."}'),
                Text('Is VPN Enabled: ${_isVpnEnabled ?? "loading..."}'),
                Text('Is Screenshot Disabled: $_isScreenshotDisabled'),
                Text('Is Debugger Attached: ${_isDebuggerAttached ?? "loading..."}'),
                Text('Is App Cloned: ${_isAppCloned ?? "loading..."}'),
                ValueListenableBuilder<bool>(
                  valueListenable: _appGuardPlugin.isClipboardProtected,
                  builder: (context, value, _) => Text('Is Copy paste Enabled: ${!value}'),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Clipboard Protection"),
                  subtitle: !_copyPasteEnable ? const Text("Enabled") : const Text("Disabled"),
                  trailing: Switch.adaptive(
                    value: !_copyPasteEnable,
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
                ListTile(
                  title: const Text("Screen Capturing and Screensharing"),
                  subtitle: _isScreenshotDisabled
                      ? const Text("Allowed")
                      : const Text("Restricted"),
                  trailing: Switch.adaptive(
                    value: _isScreenshotDisabled,
                    onChanged: (value) {
                      _appGuardPlugin.setScreenshotProtection(enabled: _isScreenshotDisabled);
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
