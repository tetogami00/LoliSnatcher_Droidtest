import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:lolisnatcher/src/handlers/keyboard_handler.dart';
import 'package:lolisnatcher/src/handlers/settings_handler.dart';
import 'package:lolisnatcher/src/widgets/common/flash_elements.dart';
import 'package:lolisnatcher/src/widgets/common/settings_widgets.dart';

class KeyboardSettingsPage extends StatefulWidget {
  const KeyboardSettingsPage({super.key});

  @override
  State<KeyboardSettingsPage> createState() => _KeyboardSettingsPageState();
}

class _KeyboardSettingsPageState extends State<KeyboardSettingsPage> {
  final SettingsHandler settingsHandler = SettingsHandler.instance;
  final KeyboardHandler keyboardHandler = KeyboardHandler.instance;
  
  late bool keyboardControlEnabled;
  Map<String, KeyboardAction> currentKeybinds = {};
  String? recordingAction;

  @override
  void initState() {
    super.initState();
    keyboardControlEnabled = settingsHandler.keyboardControlEnabled;
    currentKeybinds = Map.from(keyboardHandler.keybinds);
  }

  @override
  void dispose() {
    // Save settings when leaving the page
    settingsHandler.keyboardControlEnabled = keyboardControlEnabled;
    super.dispose();
  }

  void _startRecording(KeyboardAction action) {
    setState(() {
      recordingAction = action.name;
    });
  }

  void _stopRecording() {
    setState(() {
      recordingAction = null;
    });
  }

  void _onKeyEvent(KeyEvent event) {
    if (recordingAction != null && event is KeyDownEvent) {
      final String keyId = _getKeyId(event);
      final KeyboardAction action = KeyboardAction.values
          .firstWhere((a) => a.name == recordingAction);

      setState(() {
        // Remove any existing binding for this key
        currentKeybinds.removeWhere((key, value) => key == keyId);
        // Add new binding
        currentKeybinds[keyId] = action;
        recordingAction = null;
      });

      // Update the keyboard handler
      keyboardHandler.updateKeybind(keyId, action);

      FlashElements.showSnackbar(
        context: context,
        title: Text('Keybind Updated'),
        content: Text('${action.displayName} is now bound to ${KeyboardHandler.getKeyDisplayName(keyId)}'),
        leadingIcon: Icons.keyboard,
        leadingIconColor: Colors.green,
        sideColor: Colors.green,
      );
    }
  }

  String _getKeyId(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.space) return 'Space';
    if (event.logicalKey == LogicalKeyboardKey.escape) return 'Escape';
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) return 'ArrowUp';
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) return 'ArrowDown';
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) return 'ArrowLeft';
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) return 'ArrowRight';
    if (event.logicalKey == LogicalKeyboardKey.equal) return 'Equal';
    if (event.logicalKey == LogicalKeyboardKey.minus) return 'Minus';
    
    // Handle letter keys
    final String keyLabel = event.logicalKey.keyLabel;
    if (keyLabel.length == 1 && keyLabel.toUpperCase().codeUnitAt(0) >= 65 && keyLabel.toUpperCase().codeUnitAt(0) <= 90) {
      return 'Key${keyLabel.toUpperCase()}';
    }
    
    return event.logicalKey.keyLabel;
  }

  void _removeKeybind(String key, KeyboardAction action) {
    setState(() {
      currentKeybinds.remove(key);
    });
    keyboardHandler.removeKeybind(key);

    FlashElements.showSnackbar(
      context: context,
      title: Text('Keybind Removed'),
      content: Text('${action.displayName} keybind removed'),
      leadingIcon: Icons.keyboard,
      leadingIconColor: Colors.orange,
      sideColor: Colors.orange,
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Keybinds'),
        content: const Text('Are you sure you want to reset all keybinds to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              keyboardHandler.resetToDefaults();
              setState(() {
                currentKeybinds = Map.from(keyboardHandler.keybinds);
              });
              Navigator.of(context).pop();
              
              FlashElements.showSnackbar(
                context: context,
                title: Text('Keybinds Reset'),
                content: Text('All keybinds have been reset to default values'),
                leadingIcon: Icons.refresh,
                leadingIconColor: Colors.blue,
                sideColor: Colors.blue,
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (recordingAction != null) {
          _onKeyEvent(event);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Settings'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetToDefaults,
              tooltip: 'Reset to defaults',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SettingsToggle(
              value: keyboardControlEnabled,
              onChanged: (value) {
                setState(() {
                  keyboardControlEnabled = value;
                });
              },
              title: 'Enable Keyboard Control',
            ),
            const SizedBox(height: 16),
            if (keyboardControlEnabled) ...[
              const Text(
                'Keyboard Shortcuts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Click "Record" next to an action and press a key to assign it.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              if (recordingAction != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.keyboard, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recording keybind for "${KeyboardAction.values.firstWhere((a) => a.name == recordingAction).displayName}". Press any key...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: _stopRecording,
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              ...KeyboardAction.values.map((action) {
                final String? boundKey = currentKeybinds.entries
                    .where((entry) => entry.value == action)
                    .map((entry) => entry.key)
                    .firstOrNull;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(action.displayName),
                    subtitle: Text(action.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (boundKey != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              KeyboardHandler.getKeyDisplayName(boundKey),
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _removeKeybind(boundKey, action),
                            tooltip: 'Remove keybind',
                          ),
                        ] else
                          const Text('Not assigned', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: recordingAction == null ? () => _startRecording(action) : null,
                          child: Text(recordingAction == action.name ? 'Recording...' : 'Record'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ] else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Keyboard control is disabled. Enable it above to configure shortcuts.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
