import 'package:flutter/services.dart';
import 'package:lolisnatcher/src/data/keybind_action.dart';

/// Represents a key combination that can trigger an action
class KeyCombination {
  const KeyCombination({
    required this.key,
    this.isControl = false,
    this.isShift = false,
    this.isAlt = false,
    this.isMeta = false,
  });

  final LogicalKeyboardKey key;
  final bool isControl;
  final bool isShift;
  final bool isAlt;
  final bool isMeta;

  /// Create from a key event
  factory KeyCombination.fromKeyEvent(KeyEvent event) {
    return KeyCombination(
      key: event.logicalKey,
      isControl: HardwareKeyboard.instance.isControlPressed,
      isShift: HardwareKeyboard.instance.isShiftPressed,
      isAlt: HardwareKeyboard.instance.isAltPressed,
      isMeta: HardwareKeyboard.instance.isMetaPressed,
    );
  }

  /// Create from a JSON map
  factory KeyCombination.fromJson(Map<String, dynamic> json) {
    return KeyCombination(
      key: LogicalKeyboardKey(json['key'] as int),
      isControl: json['isControl'] as bool? ?? false,
      isShift: json['isShift'] as bool? ?? false,
      isAlt: json['isAlt'] as bool? ?? false,
      isMeta: json['isMeta'] as bool? ?? false,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'key': key.keyId,
      'isControl': isControl,
      'isShift': isShift,
      'isAlt': isAlt,
      'isMeta': isMeta,
    };
  }

  /// Get a human-readable string representation
  String get displayString {
    final List<String> parts = [];
    
    if (isMeta) parts.add('Cmd');
    if (isControl) parts.add('Ctrl');
    if (isAlt) parts.add('Alt');
    if (isShift) parts.add('Shift');
    
    final keyName = _getKeyDisplayName(key);
    parts.add(keyName);
    
    return parts.join(' + ');
  }

  /// Get display name for a key
  String _getKeyDisplayName(LogicalKeyboardKey key) {
    // Handle common keys with readable names
    if (key == LogicalKeyboardKey.space) return 'Space';
    if (key == LogicalKeyboardKey.enter) return 'Enter';
    if (key == LogicalKeyboardKey.backspace) return 'Backspace';
    if (key == LogicalKeyboardKey.tab) return 'Tab';
    if (key == LogicalKeyboardKey.escape) return 'Esc';
    if (key == LogicalKeyboardKey.delete) return 'Delete';
    if (key == LogicalKeyboardKey.home) return 'Home';
    if (key == LogicalKeyboardKey.end) return 'End';
    if (key == LogicalKeyboardKey.pageUp) return 'Page Up';
    if (key == LogicalKeyboardKey.pageDown) return 'Page Down';
    if (key == LogicalKeyboardKey.arrowUp) return '↑';
    if (key == LogicalKeyboardKey.arrowDown) return '↓';
    if (key == LogicalKeyboardKey.arrowLeft) return '←';
    if (key == LogicalKeyboardKey.arrowRight) return '→';
    
    // Function keys
    if (key == LogicalKeyboardKey.f1) return 'F1';
    if (key == LogicalKeyboardKey.f2) return 'F2';
    if (key == LogicalKeyboardKey.f3) return 'F3';
    if (key == LogicalKeyboardKey.f4) return 'F4';
    if (key == LogicalKeyboardKey.f5) return 'F5';
    if (key == LogicalKeyboardKey.f6) return 'F6';
    if (key == LogicalKeyboardKey.f7) return 'F7';
    if (key == LogicalKeyboardKey.f8) return 'F8';
    if (key == LogicalKeyboardKey.f9) return 'F9';
    if (key == LogicalKeyboardKey.f10) return 'F10';
    if (key == LogicalKeyboardKey.f11) return 'F11';
    if (key == LogicalKeyboardKey.f12) return 'F12';
    
    // Numbers
    if (key == LogicalKeyboardKey.digit0) return '0';
    if (key == LogicalKeyboardKey.digit1) return '1';
    if (key == LogicalKeyboardKey.digit2) return '2';
    if (key == LogicalKeyboardKey.digit3) return '3';
    if (key == LogicalKeyboardKey.digit4) return '4';
    if (key == LogicalKeyboardKey.digit5) return '5';
    if (key == LogicalKeyboardKey.digit6) return '6';
    if (key == LogicalKeyboardKey.digit7) return '7';
    if (key == LogicalKeyboardKey.digit8) return '8';
    if (key == LogicalKeyboardKey.digit9) return '9';
    
    // Letters - use the key label or fallback to keyId
    final keyLabel = key.keyLabel;
    if (keyLabel.isNotEmpty) {
      return keyLabel.toUpperCase();
    }
    
    return 'Key${key.keyId}';
  }

  /// Check if this combination matches a key event
  bool matches(KeyEvent event) {
    return key == event.logicalKey &&
        isControl == HardwareKeyboard.instance.isControlPressed &&
        isShift == HardwareKeyboard.instance.isShiftPressed &&
        isAlt == HardwareKeyboard.instance.isAltPressed &&
        isMeta == HardwareKeyboard.instance.isMetaPressed;
  }

  @override
  bool operator ==(Object other) {
    return other is KeyCombination &&
        key == other.key &&
        isControl == other.isControl &&
        isShift == other.isShift &&
        isAlt == other.isAlt &&
        isMeta == other.isMeta;
  }

  @override
  int get hashCode {
    return Object.hash(key, isControl, isShift, isAlt, isMeta);
  }

  @override
  String toString() => displayString;
}

/// Represents a keybind configuration mapping actions to key combinations
class KeybindConfig {
  KeybindConfig({
    Map<KeybindAction, KeyCombination>? bindings,
  }) : _bindings = bindings ?? _createDefaultBindings();

  final Map<KeybindAction, KeyCombination> _bindings;

  /// Get all configured bindings
  Map<KeybindAction, KeyCombination> get bindings => Map.from(_bindings);

  /// Get the key combination for an action
  KeyCombination? getBinding(KeybindAction action) {
    return _bindings[action];
  }

  /// Set a keybind for an action
  void setBinding(KeybindAction action, KeyCombination? combination) {
    if (combination == null) {
      _bindings.remove(action);
    } else {
      _bindings[action] = combination;
    }
  }

  /// Remove a keybind for an action
  void removeBinding(KeybindAction action) {
    _bindings.remove(action);
  }

  /// Check if a key combination is already used
  bool isBindingUsed(KeyCombination combination) {
    return _bindings.values.contains(combination);
  }

  /// Get the action bound to a key combination
  KeybindAction? getActionForBinding(KeyCombination combination) {
    for (final entry in _bindings.entries) {
      if (entry.value == combination) {
        return entry.key;
      }
    }
    return null;
  }

  /// Reset all bindings to defaults
  void resetToDefaults() {
    _bindings.clear();
    _bindings.addAll(_createDefaultBindings());
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    for (final entry in _bindings.entries) {
      result[entry.key.name] = entry.value.toJson();
    }
    return result;
  }

  /// Create from JSON
  factory KeybindConfig.fromJson(Map<String, dynamic> json) {
    final Map<KeybindAction, KeyCombination> bindings = {};
    
    for (final entry in json.entries) {
      final actionName = entry.key;
      final combinationData = entry.value as Map<String, dynamic>;
      
      // Find the action by name
      final action = KeybindAction.values.cast<KeybindAction?>().firstWhere(
        (a) => a?.name == actionName,
        orElse: () => null,
      );
      
      if (action != null) {
        bindings[action] = KeyCombination.fromJson(combinationData);
      }
    }
    
    return KeybindConfig(bindings: bindings);
  }

  /// Create default keybind mappings
  static Map<KeybindAction, KeyCombination> _createDefaultBindings() {
    return {
      // Media Controls
      KeybindAction.playPause: const KeyCombination(key: LogicalKeyboardKey.space),
      KeybindAction.seekForward: const KeyCombination(key: LogicalKeyboardKey.arrowRight),
      KeybindAction.seekBackward: const KeyCombination(key: LogicalKeyboardKey.arrowLeft),
      KeybindAction.volumeUp: const KeyCombination(key: LogicalKeyboardKey.arrowUp),
      KeybindAction.volumeDown: const KeyCombination(key: LogicalKeyboardKey.arrowDown),
      KeybindAction.fastForward: const KeyCombination(key: LogicalKeyboardKey.arrowRight, isShift: true),
      
      // Navigation
      KeybindAction.nextImage: const KeyCombination(key: LogicalKeyboardKey.arrowRight, isControl: true),
      KeybindAction.previousImage: const KeyCombination(key: LogicalKeyboardKey.arrowLeft, isControl: true),
      KeybindAction.openViewer: const KeyCombination(key: LogicalKeyboardKey.enter),
      KeybindAction.closeViewer: const KeyCombination(key: LogicalKeyboardKey.escape),
      
      // Gallery Controls
      KeybindAction.zoomIn: const KeyCombination(key: LogicalKeyboardKey.equal, isControl: true),
      KeybindAction.zoomOut: const KeyCombination(key: LogicalKeyboardKey.minus, isControl: true),
      KeybindAction.resetZoom: const KeyCombination(key: LogicalKeyboardKey.digit0, isControl: true),
      KeybindAction.toggleFullscreen: const KeyCombination(key: LogicalKeyboardKey.f11),
      
      // App Navigation
      KeybindAction.nextTab: const KeyCombination(key: LogicalKeyboardKey.tab, isControl: true),
      KeybindAction.previousTab: const KeyCombination(key: LogicalKeyboardKey.tab, isControl: true, isShift: true),
      KeybindAction.openSettings: const KeyCombination(key: LogicalKeyboardKey.comma, isControl: true),
      KeybindAction.openSearch: const KeyCombination(key: LogicalKeyboardKey.keyF, isControl: true),
      KeybindAction.toggleDrawer: const KeyCombination(key: LogicalKeyboardKey.keyM, isControl: true),
      
      // Selection and Downloads
      KeybindAction.selectItem: const KeyCombination(key: LogicalKeyboardKey.space, isControl: true),
      KeybindAction.selectAll: const KeyCombination(key: LogicalKeyboardKey.keyA, isControl: true),
      KeybindAction.clearSelection: const KeyCombination(key: LogicalKeyboardKey.escape, isControl: true),
      KeybindAction.downloadSelected: const KeyCombination(key: LogicalKeyboardKey.keyS, isControl: true),
      
      // Search and Tags
      KeybindAction.focusSearch: const KeyCombination(key: LogicalKeyboardKey.slash, isControl: true),
      KeybindAction.clearSearch: const KeyCombination(key: LogicalKeyboardKey.backspace, isControl: true),
      KeybindAction.refreshSearch: const KeyCombination(key: LogicalKeyboardKey.f5),
      KeybindAction.toggleFavorite: const KeyCombination(key: LogicalKeyboardKey.keyF),
      
      // UI Controls
      KeybindAction.toggleAppbar: const KeyCombination(key: LogicalKeyboardKey.f1),
      KeybindAction.toggleBottomBar: const KeyCombination(key: LogicalKeyboardKey.f2),
      KeybindAction.toggleNotes: const KeyCombination(key: LogicalKeyboardKey.f3),
      KeybindAction.toggleVideoControls: const KeyCombination(key: LogicalKeyboardKey.f4),
    };
  }
}
