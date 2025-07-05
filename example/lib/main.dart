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
      _copyPasteEnable = false;

  final _appGuardPlugin = AppGuard(
    applicationID: "com.security.app_guard",
    initialClipboardProtection: true,
    initialScreenshotProtection: true,
  );

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
                Text('Running on: ${_appGuardPlugin.getPlatformVersion }\n'),
                Text('Is Device Safe: ${_appGuardPlugin.isDeviceSafe}\n'),
                const Divider(),
                const Text('Checklist', textAlign: TextAlign.center),
                const Divider(),
                Text('Is Device Rooted: ${_appGuardPlugin.isDeviceRooted}'),
                Text('Is Debugging Mode Enable: ${_appGuardPlugin.isDebuggingModeEnabled}'),
                Text('Is Developer Mode Enabled: ${_appGuardPlugin.isDeveloperModeEnabled}'),
                Text('Is Emulator: ${_appGuardPlugin.isEmulator}'),
                Text('Is VPN Enabled: ${_appGuardPlugin.isVpnEnabled}'),
                Text('Is Screenshot Disabled: $_isScreenshotDisabled'),
                Text('Is Debugger Attached: ${_appGuardPlugin.isDebuggerAttached}'),
                Text('Is App Cloned: ${_appGuardPlugin.isAppCloned}'),
                Text('Is Copy paste Enabled: ${_appGuardPlugin.isClipboardProtected}'),
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
                        _appGuardPlugin.setScreenshotProtection(enabled: false);
                      } else {
                        _appGuardPlugin.setScreenshotProtection(enabled: true);
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
