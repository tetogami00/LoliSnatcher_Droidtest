import 'dart:async';

import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:lolisnatcher/src/handlers/settings_handler.dart';
import 'package:lolisnatcher/src/handlers/viewer_handler.dart';

/// Keyboard handler for managing keyboard shortcuts and custom keybinds
class KeyboardHandler {
  static KeyboardHandler get instance => GetIt.instance<KeyboardHandler>();

  static KeyboardHandler register() {
    if (!GetIt.instance.isRegistered<KeyboardHandler>()) {
      GetIt.instance.registerSingleton(KeyboardHandler());
    }
    return instance;
  }

  static void unregister() => GetIt.instance.unregister<KeyboardHandler>();

  KeyboardHandler() {
    _loadDefaultKeybinds();
  }

  final SettingsHandler _settingsHandler = SettingsHandler.instance;
  final ViewerHandler _viewerHandler = ViewerHandler.instance;

  // Stream controller for keyboard events
  final StreamController<KeyboardAction> _keyboardStreamController = StreamController.broadcast();
  
  // Current active keybinds
  Map<String, KeyboardAction> _keybinds = {};

  // Observable for UI updates when keybinds change
  final RxBool _keybindsUpdated = false.obs;

  Stream<KeyboardAction> get keyboardStream => _keyboardStreamController.stream;

  RxBool get keybindsUpdated => _keybindsUpdated;

  void dispose() {
    _keyboardStreamController.close();
  }

  /// Load default keybinds
  void _loadDefaultKeybinds() {
    _keybinds = {
      // Navigation
      'ArrowRight': KeyboardAction.nextPost,
      'ArrowLeft': KeyboardAction.previousPost,
      'ArrowUp': KeyboardAction.zoomIn,
      'ArrowDown': KeyboardAction.zoomOut,
      
      // Media control
      'Space': KeyboardAction.playPause,
      'KeyM': KeyboardAction.mute,
      'Equal': KeyboardAction.volumeUp,
      'Minus': KeyboardAction.volumeDown,
      'KeyD': KeyboardAction.skipVideoForward,
      
      // Information display
      'KeyI': KeyboardAction.showInfo,
      'KeyT': KeyboardAction.showTags,
      
      // UI control
      'KeyH': KeyboardAction.toggleUI,
      'KeyF': KeyboardAction.toggleFullscreen,
      'Escape': KeyboardAction.exitFullscreen,
    };
    _keybindsUpdated.value = !_keybindsUpdated.value;
  }

  /// Get current keybinds for settings display
  Map<String, KeyboardAction> get keybinds => Map.from(_keybinds);

  /// Update a specific keybind
  void updateKeybind(String key, KeyboardAction action) {
    // Remove any existing binding for this action
    _keybinds.removeWhere((k, v) => v == action);
    
    // Add new binding
    if (key.isNotEmpty) {
      _keybinds[key] = action;
    }
    
    _keybindsUpdated.value = !_keybindsUpdated.value;
    _saveKeybinds();
  }

  /// Remove a keybind
  void removeKeybind(String key) {
    _keybinds.remove(key);
    _keybindsUpdated.value = !_keybindsUpdated.value;
    _saveKeybinds();
  }

  /// Reset to default keybinds
  void resetToDefaults() {
    _loadDefaultKeybinds();
    _saveKeybinds();
  }

  /// Handle raw keyboard event
  bool handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final String keyId = _getKeyId(event);
    final KeyboardAction? action = _keybinds[keyId];
    
    if (action != null) {
      _executeAction(action);
      _keyboardStreamController.add(action);
      return true;
    }
    
    return false;
  }

  /// Convert KeyEvent to string identifier
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

  /// Execute the keyboard action
  void _executeAction(KeyboardAction action) {
    switch (action) {
      case KeyboardAction.nextPost:
        // Will be handled by gallery view page
        break;
      case KeyboardAction.previousPost:
        // Will be handled by gallery view page
        break;
      case KeyboardAction.zoomIn:
        _viewerHandler.doubleTapZoom();
        break;
      case KeyboardAction.zoomOut:
        _viewerHandler.resetZoom();
        break;
      case KeyboardAction.playPause:
        _viewerHandler.togglePlayPause();
        break;
      case KeyboardAction.mute:
        _viewerHandler.toggleMuteAllVideos();
        break;
      case KeyboardAction.volumeUp:
        _viewerHandler.adjustVolume(0.1);
        break;
      case KeyboardAction.volumeDown:
        _viewerHandler.adjustVolume(-0.1);
        break;
      case KeyboardAction.skipVideoForward:
        _viewerHandler.skipVideoForward(const Duration(seconds: 5));
        break;
      case KeyboardAction.showInfo:
        // Will be implemented
        break;
      case KeyboardAction.showTags:
        // Will be implemented
        break;
      case KeyboardAction.toggleUI:
        _viewerHandler.displayAppbar.value = !_viewerHandler.displayAppbar.value;
        break;
      case KeyboardAction.toggleFullscreen:
        _viewerHandler.setFullScreenState(!_viewerHandler.isFullscreen.value);
        break;
      case KeyboardAction.exitFullscreen:
        _viewerHandler.setFullScreenState(false);
        break;
    }
  }

  /// Save keybinds to settings
  void _saveKeybinds() {
    // Convert keybinds to JSON-serializable format
    final Map<String, String> keybindsMap = {};
    _keybinds.forEach((key, action) {
      keybindsMap[key] = action.name;
    });
    
    // Save to settings handler
    _settingsHandler.customKeybinds = keybindsMap;
  }

  /// Load keybinds from settings
  void loadKeybinds() {
    final Map<String, String> savedKeybinds = _settingsHandler.customKeybinds;
    
    if (savedKeybinds.isNotEmpty) {
      _keybinds.clear();
      savedKeybinds.forEach((key, actionName) {
        final KeyboardAction? action = KeyboardAction.values.cast<KeyboardAction?>()
            .firstWhere((a) => a?.name == actionName, orElse: () => null);
        if (action != null) {
          _keybinds[key] = action;
        }
      });
      _keybindsUpdated.value = !_keybindsUpdated.value;
    }
  }

  /// Get human-readable key name
  static String getKeyDisplayName(String keyId) {
    switch (keyId) {
      case 'Space': return 'Space';
      case 'Escape': return 'Esc';
      case 'ArrowUp': return '↑';
      case 'ArrowDown': return '↓';
      case 'ArrowLeft': return '←';
      case 'ArrowRight': return '→';
      case 'Equal': return '+';
      case 'Minus': return '-';
      default:
        if (keyId.startsWith('Key')) {
          return keyId.substring(3);
        }
        return keyId;
    }
  }
}

/// Available keyboard actions
enum KeyboardAction {
  nextPost,
  previousPost,
  zoomIn,
  zoomOut,
  playPause,
  mute,
  volumeUp,
  volumeDown,
  skipVideoForward,
  showInfo,
  showTags,
  toggleUI,
  toggleFullscreen,
  exitFullscreen,
}

/// Extension for getting display names of keyboard actions
extension KeyboardActionExtension on KeyboardAction {
  String get displayName {
    switch (this) {
      case KeyboardAction.nextPost:
        return 'Next Post';
      case KeyboardAction.previousPost:
        return 'Previous Post';
      case KeyboardAction.zoomIn:
        return 'Zoom In';
      case KeyboardAction.zoomOut:
        return 'Zoom Out';
      case KeyboardAction.playPause:
        return 'Play/Pause';
      case KeyboardAction.mute:
        return 'Mute/Unmute';
      case KeyboardAction.volumeUp:
        return 'Volume Up';
      case KeyboardAction.volumeDown:
        return 'Volume Down';
      case KeyboardAction.skipVideoForward:
        return 'Skip Video Forward';
      case KeyboardAction.showInfo:
        return 'Show Info';
      case KeyboardAction.showTags:
        return 'Show Tags';
      case KeyboardAction.toggleUI:
        return 'Toggle UI';
      case KeyboardAction.toggleFullscreen:
        return 'Toggle Fullscreen';
      case KeyboardAction.exitFullscreen:
        return 'Exit Fullscreen';
    }
  }

  String get description {
    switch (this) {
      case KeyboardAction.nextPost:
        return 'Navigate to the next post';
      case KeyboardAction.previousPost:
        return 'Navigate to the previous post';
      case KeyboardAction.zoomIn:
        return 'Zoom in on the current image';
      case KeyboardAction.zoomOut:
        return 'Zoom out of the current image';
      case KeyboardAction.playPause:
        return 'Play or pause video playback';
      case KeyboardAction.mute:
        return 'Mute or unmute video audio';
      case KeyboardAction.volumeUp:
        return 'Increase video volume';
      case KeyboardAction.volumeDown:
        return 'Decrease video volume';
      case KeyboardAction.skipVideoForward:
        return 'Skip video forward by 5 seconds';
      case KeyboardAction.showInfo:
        return 'Display post information';
      case KeyboardAction.showTags:
        return 'Display post tags';
      case KeyboardAction.toggleUI:
        return 'Show or hide the interface';
      case KeyboardAction.toggleFullscreen:
        return 'Enter or exit fullscreen mode';
      case KeyboardAction.exitFullscreen:
        return 'Exit fullscreen mode';
    }
  }
}
