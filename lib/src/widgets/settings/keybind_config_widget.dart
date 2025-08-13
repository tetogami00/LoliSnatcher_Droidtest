import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lolisnatcher/src/data/keybind_action.dart';
import 'package:lolisnatcher/src/data/keybind_config.dart';
import 'package:lolisnatcher/src/handlers/input_handler.dart';

/// Widget for configuring a single keybind
class KeybindConfigWidget extends StatefulWidget {
  const KeybindConfigWidget({
    required this.action,
    required this.onChanged,
    super.key,
  });

  final KeybindAction action;
  final ValueChanged<KeyCombination?> onChanged;

  @override
  State<KeybindConfigWidget> createState() => _KeybindConfigWidgetState();
}

class _KeybindConfigWidgetState extends State<KeybindConfigWidget> {
  final InputHandler _inputHandler = InputHandler.instance;
  final FocusNode _recordingFocusNode = FocusNode();
  bool _isRecording = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _recordingFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _recordingFocusNode.removeListener(_onFocusChange);
    _recordingFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_recordingFocusNode.hasFocus && _isRecording) {
      _stopRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _recordingFocusNode,
      onKeyEvent: _isRecording ? _handleKeyEvent : null,
      child: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    final currentBinding = _inputHandler.getKeybind(widget.action);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.action.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (widget.action.description.isNotEmpty)
                        Text(
                          widget.action.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildKeybindDisplay(currentBinding),
                const SizedBox(width: 8),
                _buildActionButtons(currentBinding),
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeybindDisplay(KeyCombination? binding) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4),
        color: _isRecording 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
      ),
      child: Text(
        _isRecording 
            ? 'Press keys...'
            : binding?.displayString ?? 'Not set',
        style: TextStyle(
          fontFamily: 'monospace',
          color: _isRecording 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _buildActionButtons(KeyCombination? binding) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _isRecording ? null : _startRecording,
          icon: Icon(_isRecording ? Icons.radio_button_checked : Icons.edit),
          tooltip: _isRecording ? 'Recording...' : 'Edit keybind',
        ),
        if (binding != null)
          IconButton(
            onPressed: _isRecording ? null : _clearBinding,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear keybind',
          ),
      ],
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _errorMessage = null;
    });

    // Focus this widget to capture key events
    FocusScope.of(context).requestFocus(_recordingFocusNode);
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
  }

  void _clearBinding() {
    _inputHandler.updateKeybind(widget.action, null);
    widget.onChanged(null);
    _inputHandler.saveKeybinds();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isRecording || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    // Ignore modifier-only keys
    if (event.logicalKey == LogicalKeyboardKey.control ||
        event.logicalKey == LogicalKeyboardKey.shift ||
        event.logicalKey == LogicalKeyboardKey.alt ||
        event.logicalKey == LogicalKeyboardKey.meta) {
      return KeyEventResult.handled;
    }

    try {
      final combination = KeyCombination.fromKeyEvent(event);
      
      // Check if this combination is already in use
      if (_inputHandler.isKeybindInUse(combination)) {
        final existingAction = _inputHandler.keybindConfig.getActionForBinding(combination);
        if (existingAction != null && existingAction != widget.action) {
          setState(() {
            _errorMessage = 'This key combination is already used by "${existingAction.displayName}"';
          });
          _stopRecording();
          return KeyEventResult.handled;
        }
      }

      // Set the new binding
      _inputHandler.updateKeybind(widget.action, combination);
      widget.onChanged(combination);
      _inputHandler.saveKeybinds();
      
      setState(() {
        _errorMessage = null;
      });
      _stopRecording();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to record key combination: $e';
      });
      _stopRecording();
    }

    return KeyEventResult.handled;
  }
}
