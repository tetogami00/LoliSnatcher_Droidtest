import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:lolisnatcher/src/data/keybind_action.dart';
import 'package:lolisnatcher/src/data/keybind_config.dart';
import 'package:lolisnatcher/src/handlers/settings_handler.dart';
import 'package:lolisnatcher/src/utils/logger.dart';

/// Handler for managing global keyboard and controller input for Quest 3 compatibility
class InputHandler {
  static InputHandler get instance => GetIt.instance<InputHandler>();

  static InputHandler register() {
    if (!GetIt.instance.isRegistered<InputHandler>()) {
      GetIt.instance.registerSingleton(InputHandler());
    }
    return instance;
  }

  static void unregister() => GetIt.instance.unregister<InputHandler>();

  final SettingsHandler _settingsHandler = SettingsHandler.instance;
  
  KeybindConfig _keybindConfig = KeybindConfig();
  final Map<KeybindAction, VoidCallback> _actionHandlers = {};
  
  bool _isInitialized = false;
  bool _isListening = false;
  
  /// Get the current keybind configuration
  KeybindConfig get keybindConfig => _keybindConfig;

  /// Initialize the input handler
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load keybind configuration from settings
      await _loadKeybinds();
      
      // Start listening to hardware keyboard events
      _startListening();
      
      _isInitialized = true;
      Logger.Inst().log('Input handler initialized', 'InputHandler', 'initialize', LogTypes.settingsLoad);
    } catch (e) {
      Logger.Inst().log('Failed to initialize input handler: $e', 'InputHandler', 'initialize', LogTypes.settingsLoad);
    }
  }

  /// Load keybind configuration from settings
  Future<void> _loadKeybinds() async {
    try {
      final keybindData = _settingsHandler.keybindConfig;
      if (keybindData.isNotEmpty) {
        _keybindConfig = KeybindConfig.fromJson(keybindData);
      }
    } catch (e) {
      Logger.Inst().log('Failed to load keybinds, using defaults: $e', 'InputHandler', '_loadKeybinds', LogTypes.settingsLoad);
      _keybindConfig = KeybindConfig();
    }
  }

  /// Save keybind configuration to settings
  Future<void> saveKeybinds() async {
    try {
      _settingsHandler.keybindConfig = _keybindConfig.toJson();
      await _settingsHandler.saveSettings(restate: false);
      Logger.Inst().log('Keybinds saved successfully', 'InputHandler', 'saveKeybinds', LogTypes.settingsLoad);
    } catch (e) {
      Logger.Inst().log('Failed to save keybinds: $e', 'InputHandler', 'saveKeybinds', LogTypes.settingsLoad);
    }
  }

  /// Start listening to hardware keyboard events
  void _startListening() {
    if (_isListening) return;
    
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    _isListening = true;
    Logger.Inst().log('Started listening for keyboard events', 'InputHandler', '_startListening', LogTypes.settingsLoad);
  }

  /// Stop listening to hardware keyboard events
  void _stopListening() {
    if (!_isListening) return;
    
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _isListening = false;
    Logger.Inst().log('Stopped listening for keyboard events', 'InputHandler', '_stopListening', LogTypes.settingsLoad);
  }

  /// Handle keyboard events
  bool _handleKeyEvent(KeyEvent event) {
    // Only handle key down events to avoid duplicates
    if (event is! KeyDownEvent) return false;
    
    try {
      final combination = KeyCombination.fromKeyEvent(event);
      final action = _keybindConfig.getActionForBinding(combination);
      
      if (action != null) {
        final handler = _actionHandlers[action];
        if (handler != null) {
          handler();
          Logger.Inst().log('Executed action: ${action.displayName} for ${combination.displayString}', 
                          'InputHandler', '_handleKeyEvent', LogTypes.settingsLoad);
          return true; // Event was handled
        }
      }
    } catch (e) {
      Logger.Inst().log('Error handling key event: $e', 'InputHandler', '_handleKeyEvent', LogTypes.settingsLoad);
    }
    
    return false; // Event was not handled
  }

  /// Register an action handler
  void registerActionHandler(KeybindAction action, VoidCallback handler) {
    _actionHandlers[action] = handler;
    Logger.Inst().log('Registered handler for action: ${action.displayName}', 
                     'InputHandler', 'registerActionHandler', LogTypes.settingsLoad);
  }

  /// Unregister an action handler
  void unregisterActionHandler(KeybindAction action) {
    _actionHandlers.remove(action);
    Logger.Inst().log('Unregistered handler for action: ${action.displayName}', 
                     'InputHandler', 'unregisterActionHandler', LogTypes.settingsLoad);
  }

  /// Update a keybind
  void updateKeybind(KeybindAction action, KeyCombination? combination) {
    _keybindConfig.setBinding(action, combination);
    Logger.Inst().log(combination != null 
                     ? 'Updated keybind for ${action.displayName}: ${combination.displayString}'
                     : 'Removed keybind for ${action.displayName}', 
                     'InputHandler', 'updateKeybind', LogTypes.settingsLoad);
  }

  /// Get the key combination for an action
  KeyCombination? getKeybind(KeybindAction action) {
    return _keybindConfig.getBinding(action);
  }

  /// Check if a key combination is already in use
  bool isKeybindInUse(KeyCombination combination) {
    return _keybindConfig.isBindingUsed(combination);
  }

  /// Reset all keybinds to defaults
  void resetKeybindsToDefaults() {
    _keybindConfig.resetToDefaults();
    Logger.Inst().log('Reset all keybinds to defaults', 'InputHandler', 'resetKeybindsToDefaults', LogTypes.settingsLoad);
  }

  /// Get all actions grouped by category
  Map<KeybindCategory, List<KeybindAction>> getActionsByCategory() {
    final Map<KeybindCategory, List<KeybindAction>> result = {};
    
    for (final category in KeybindCategory.values) {
      result[category] = KeybindAction.values
          .where((action) => action.category == category)
          .toList();
    }
    
    return result;
  }

  /// Dispose of the input handler
  void dispose() {
    _stopListening();
    _actionHandlers.clear();
    _isInitialized = false;
    Logger.Inst().log('Input handler disposed', 'InputHandler', 'dispose', LogTypes.settingsLoad);
  }
}
