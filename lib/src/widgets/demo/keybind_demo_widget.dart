import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lolisnatcher/src/data/keybind_action.dart';
import 'package:lolisnatcher/src/data/keybind_config.dart';
import 'package:lolisnatcher/src/handlers/input_handler.dart';

/// Example demo widget showing keybind functionality
class KeybindDemoWidget extends StatefulWidget {
  const KeybindDemoWidget({super.key});

  @override
  State<KeybindDemoWidget> createState() => _KeybindDemoWidgetState();
}

class _KeybindDemoWidgetState extends State<KeybindDemoWidget> {
  final InputHandler _inputHandler = InputHandler.instance;
  String _lastAction = 'None';
  String _lastKeyPressed = 'None';

  @override
  void initState() {
    super.initState();
    _setupDemo();
  }

  void _setupDemo() {
    // Register a demo handler for all actions to show when they're triggered
    for (final action in KeybindAction.values) {
      _inputHandler.registerActionHandler(action, () {
        setState(() {
          _lastAction = action.displayName;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest 3 Keybind Demo'),
      ),
      body: Focus(
        onKeyEvent: _handleRawKeyEvent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quest 3 Controller Support Demo',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This demonstrates the Quest 3 controller support implementation for LoliSnatcher. '
                        'Global keyboard input is captured and mapped to application actions.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input Detection',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Last Key Pressed: '),
                          Text(
                            _lastKeyPressed,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Last Action Triggered: '),
                          Text(
                            _lastAction,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Try These Default Bindings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _buildKeybindDemo('Space', 'Play/Pause'),
                      _buildKeybindDemo('Ctrl + Right', 'Next Image'),
                      _buildKeybindDemo('Ctrl + Left', 'Previous Image'),
                      _buildKeybindDemo('Enter', 'Open Viewer'),
                      _buildKeybindDemo('Escape', 'Close Viewer'),
                      _buildKeybindDemo('F11', 'Toggle Fullscreen'),
                      _buildKeybindDemo('Ctrl + A', 'Select All'),
                      _buildKeybindDemo('Ctrl + S', 'Download Selected'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'To configure keybinds, go to Settings → Interface → "Keyboard & Controller Settings".\n\n'
                        'For Quest 3 usage:\n'
                        '1. Connect via Quest Link/Air Link\n'
                        '2. Map Quest controllers to keyboard inputs\n'
                        '3. Use configured keybinds to control LoliSnatcher\n'
                        '4. Input works even when window is not focused',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeybindDemo(String keys, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              keys,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          const Text('→'),
          const SizedBox(width: 8),
          Text(action),
        ],
      ),
    );
  }

  KeyEventResult _handleRawKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final combination = KeyCombination.fromKeyEvent(event);
      setState(() {
        _lastKeyPressed = combination.displayString;
      });
    }
    return KeyEventResult.ignored; // Let the InputHandler also process it
  }
}