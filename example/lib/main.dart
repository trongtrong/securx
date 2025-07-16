import 'package:flutter/material.dart';
import 'package:securx/securx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _copyPasteEnable = true, _isScreenshotEnabled = false;

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

  final _secuxPlugin = Securx(
    applicationID: "com.security.securx.securx",
    initialClipboardProtection: true,
  );

  @override
  void initState() {
    super.initState();
    _fetchDeviceSecurityInfo();

    // Set initial copy/paste state from plugin
    _copyPasteEnable = !_secuxPlugin.isClipboardProtected.value;

    _secuxPlugin.isClipboardProtected.addListener(() {
      setState(() {
        _copyPasteEnable = !_secuxPlugin.isClipboardProtected.value;
      });
    });

    // Ensure screenshot protection is set after activity is ready and update UI state
    // Initially, screenshot protection is enabled (restricted).
    _secuxPlugin.setScreenshotProtection(enabled: false);
  }

  Future<void> _fetchDeviceSecurityInfo() async {
    final platformVersion = await _secuxPlugin.getPlatformVersion;
    final isDeviceSafe = await _secuxPlugin.isDeviceSafe;
    final isDeviceRooted = await _secuxPlugin.isDeviceRooted;
    final isDebuggingModeEnabled = await _secuxPlugin.isDebuggingModeEnabled;
    final isDeveloperModeEnabled = await _secuxPlugin.isDeveloperModeEnabled;
    final isEmulator = await _secuxPlugin.isEmulator;
    final isVpnEnabled = await _secuxPlugin.isVpnEnabled;
    final isDebuggerAttached = await _secuxPlugin.isDebuggerAttached;
    final isAppCloned = await _secuxPlugin.isAppCloned;

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
        appBar: AppBar(title: const Text('Securx Plugin')),
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
                Text('Is Debugging Mode Enabled: ${_isDebuggingModeEnabled ?? "loading..."}'),
                Text('Is Developer Mode Enabled: ${_isDeveloperModeEnabled ?? "loading..."}'),
                Text('Is Emulator: ${_isEmulator ?? "loading..."}'),
                Text('Is VPN Enabled: ${_isVpnEnabled ?? "loading..."}'),
                Text('Is Screenshot Enabled: $_isScreenshotEnabled'),
                Text('Is Debugger Attached: ${_isDebuggerAttached ?? "loading..."}'),
                Text('Is App Cloned: ${_isAppCloned ?? "loading..."}'),
                ValueListenableBuilder<bool>(
                  valueListenable: _secuxPlugin.isClipboardProtected,
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
                  subtitle: _isScreenshotEnabled ? const Text("Allowed") : const Text("Restricted"),
                  trailing: Switch.adaptive(
                    value: _isScreenshotEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isScreenshotEnabled = value;
                        // When enabled is true, screenshots are restricted.
                        _secuxPlugin.setScreenshotProtection(enabled: !_isScreenshotEnabled);
                      });
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
