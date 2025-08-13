import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:lolisnatcher/src/data/keybind_action.dart';
import 'package:lolisnatcher/src/handlers/input_handler.dart';
import 'package:lolisnatcher/src/handlers/navigation_handler.dart';
import 'package:lolisnatcher/src/handlers/search_handler.dart';
import 'package:lolisnatcher/src/handlers/settings_handler.dart';
import 'package:lolisnatcher/src/handlers/snatch_handler.dart';
import 'package:lolisnatcher/src/handlers/viewer_handler.dart';
import 'package:lolisnatcher/src/pages/settings_page.dart';
import 'package:lolisnatcher/src/utils/logger.dart';
import 'package:lolisnatcher/src/widgets/common/flash_elements.dart';

/// Service that connects InputHandler actions to actual app functionality
class ActionService {
  static ActionService get instance => GetIt.instance<ActionService>();

  static ActionService register() {
    if (!GetIt.instance.isRegistered<ActionService>()) {
      GetIt.instance.registerSingleton(ActionService());
    }
    return instance;
  }

  static void unregister() => GetIt.instance.unregister<ActionService>();

  final SettingsHandler _settingsHandler = SettingsHandler.instance;
  final SearchHandler _searchHandler = SearchHandler.instance;
  final SnatchHandler _snatchHandler = SnatchHandler.instance;
  final ViewerHandler _viewerHandler = ViewerHandler.instance;
  final NavigationHandler _navigationHandler = NavigationHandler.instance;
  final InputHandler _inputHandler = InputHandler.instance;

  bool _isInitialized = false;

  /// Initialize the action service and register action handlers
  void initialize() {
    if (_isInitialized) return;

    _registerActionHandlers();
    _isInitialized = true;
    
    Logger.Inst().log('Action service initialized', 'ActionService', 'initialize', LogTypes.settingsLoad);
  }

  /// Register all action handlers with the input handler
  void _registerActionHandlers() {
    // Media Controls
    _inputHandler.registerActionHandler(KeybindAction.playPause, _handlePlayPause);
    _inputHandler.registerActionHandler(KeybindAction.seekForward, _handleSeekForward);
    _inputHandler.registerActionHandler(KeybindAction.seekBackward, _handleSeekBackward);
    _inputHandler.registerActionHandler(KeybindAction.volumeUp, _handleVolumeUp);
    _inputHandler.registerActionHandler(KeybindAction.volumeDown, _handleVolumeDown);
    _inputHandler.registerActionHandler(KeybindAction.fastForward, _handleFastForward);

    // Navigation
    _inputHandler.registerActionHandler(KeybindAction.nextImage, _handleNextImage);
    _inputHandler.registerActionHandler(KeybindAction.previousImage, _handlePreviousImage);
    _inputHandler.registerActionHandler(KeybindAction.openViewer, _handleOpenViewer);
    _inputHandler.registerActionHandler(KeybindAction.closeViewer, _handleCloseViewer);

    // Gallery Controls
    _inputHandler.registerActionHandler(KeybindAction.zoomIn, _handleZoomIn);
    _inputHandler.registerActionHandler(KeybindAction.zoomOut, _handleZoomOut);
    _inputHandler.registerActionHandler(KeybindAction.resetZoom, _handleResetZoom);
    _inputHandler.registerActionHandler(KeybindAction.toggleFullscreen, _handleToggleFullscreen);

    // App Navigation
    _inputHandler.registerActionHandler(KeybindAction.nextTab, _handleNextTab);
    _inputHandler.registerActionHandler(KeybindAction.previousTab, _handlePreviousTab);
    _inputHandler.registerActionHandler(KeybindAction.openSettings, _handleOpenSettings);
    _inputHandler.registerActionHandler(KeybindAction.openSearch, _handleOpenSearch);
    _inputHandler.registerActionHandler(KeybindAction.toggleDrawer, _handleToggleDrawer);

    // Selection and Downloads
    _inputHandler.registerActionHandler(KeybindAction.selectItem, _handleSelectItem);
    _inputHandler.registerActionHandler(KeybindAction.selectAll, _handleSelectAll);
    _inputHandler.registerActionHandler(KeybindAction.clearSelection, _handleClearSelection);
    _inputHandler.registerActionHandler(KeybindAction.downloadSelected, _handleDownloadSelected);

    // Search and Tags
    _inputHandler.registerActionHandler(KeybindAction.focusSearch, _handleFocusSearch);
    _inputHandler.registerActionHandler(KeybindAction.clearSearch, _handleClearSearch);
    _inputHandler.registerActionHandler(KeybindAction.refreshSearch, _handleRefreshSearch);
    _inputHandler.registerActionHandler(KeybindAction.toggleFavorite, _handleToggleFavorite);

    // UI Controls
    _inputHandler.registerActionHandler(KeybindAction.toggleAppbar, _handleToggleAppbar);
    _inputHandler.registerActionHandler(KeybindAction.toggleBottomBar, _handleToggleBottomBar);
    _inputHandler.registerActionHandler(KeybindAction.toggleNotes, _handleToggleNotes);
    _inputHandler.registerActionHandler(KeybindAction.toggleVideoControls, _handleToggleVideoControls);
  }

  // Media Control Handlers
  void _handlePlayPause() {
    // TODO: Implement play/pause for video player
    Logger.Inst().log('Play/Pause action triggered', 'ActionService', '_handlePlayPause', LogTypes.settingsLoad);
  }

  void _handleSeekForward() {
    // TODO: Implement seek forward for video player
    Logger.Inst().log('Seek forward action triggered', 'ActionService', '_handleSeekForward', LogTypes.settingsLoad);
  }

  void _handleSeekBackward() {
    // TODO: Implement seek backward for video player
    Logger.Inst().log('Seek backward action triggered', 'ActionService', '_handleSeekBackward', LogTypes.settingsLoad);
  }

  void _handleVolumeUp() {
    // TODO: Implement volume up for video player
    Logger.Inst().log('Volume up action triggered', 'ActionService', '_handleVolumeUp', LogTypes.settingsLoad);
  }

  void _handleVolumeDown() {
    // TODO: Implement volume down for video player
    Logger.Inst().log('Volume down action triggered', 'ActionService', '_handleVolumeDown', LogTypes.settingsLoad);
  }

  void _handleFastForward() {
    // TODO: Implement fast forward for video player
    Logger.Inst().log('Fast forward action triggered', 'ActionService', '_handleFastForward', LogTypes.settingsLoad);
  }

  // Navigation Handlers
  void _handleNextImage() {
    // TODO: Implement next image navigation in gallery
    Logger.Inst().log('Next image action triggered', 'ActionService', '_handleNextImage', LogTypes.settingsLoad);
  }

  void _handlePreviousImage() {
    // TODO: Implement previous image navigation in gallery
    Logger.Inst().log('Previous image action triggered', 'ActionService', '_handlePreviousImage', LogTypes.settingsLoad);
  }

  void _handleOpenViewer() {
    // TODO: Implement open viewer for current selected item
    Logger.Inst().log('Open viewer action triggered', 'ActionService', '_handleOpenViewer', LogTypes.settingsLoad);
  }

  void _handleCloseViewer() {
    final context = _navigationHandler.navigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      Logger.Inst().log('Close viewer action triggered', 'ActionService', '_handleCloseViewer', LogTypes.settingsLoad);
    }
  }

  // Gallery Control Handlers
  void _handleZoomIn() {
    // TODO: Implement zoom in for photo viewer
    Logger.Inst().log('Zoom in action triggered', 'ActionService', '_handleZoomIn', LogTypes.settingsLoad);
  }

  void _handleZoomOut() {
    // TODO: Implement zoom out for photo viewer
    Logger.Inst().log('Zoom out action triggered', 'ActionService', '_handleZoomOut', LogTypes.settingsLoad);
  }

  void _handleResetZoom() {
    // TODO: Implement reset zoom for photo viewer
    Logger.Inst().log('Reset zoom action triggered', 'ActionService', '_handleResetZoom', LogTypes.settingsLoad);
  }

  void _handleToggleFullscreen() {
    _viewerHandler.isFullscreen.value = !_viewerHandler.isFullscreen.value;
    Logger.Inst().log('Toggle fullscreen action triggered', 'ActionService', '_handleToggleFullscreen', LogTypes.settingsLoad);
  }

  // App Navigation Handlers
  void _handleNextTab() {
    if (_searchHandler.tabs.isNotEmpty) {
      final currentIndex = _searchHandler.tabs.indexOf(_searchHandler.currentTab);
      final nextIndex = (currentIndex + 1) % _searchHandler.tabs.length;
      _searchHandler.changeTabIndex(nextIndex);
      Logger.Inst().log('Next tab action triggered', 'ActionService', '_handleNextTab', LogTypes.settingsLoad);
    }
  }

  void _handlePreviousTab() {
    if (_searchHandler.tabs.isNotEmpty) {
      final currentIndex = _searchHandler.tabs.indexOf(_searchHandler.currentTab);
      final previousIndex = (currentIndex - 1 + _searchHandler.tabs.length) % _searchHandler.tabs.length;
      _searchHandler.changeTabIndex(previousIndex);
      Logger.Inst().log('Previous tab action triggered', 'ActionService', '_handlePreviousTab', LogTypes.settingsLoad);
    }
  }

  void _handleOpenSettings() {
    final context = _navigationHandler.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
      Logger.Inst().log('Open settings action triggered', 'ActionService', '_handleOpenSettings', LogTypes.settingsLoad);
    }
  }

  void _handleOpenSearch() {
    // TODO: Implement open search functionality
    Logger.Inst().log('Open search action triggered', 'ActionService', '_handleOpenSearch', LogTypes.settingsLoad);
  }

  void _handleToggleDrawer() {
    // TODO: Implement toggle drawer functionality
    Logger.Inst().log('Toggle drawer action triggered', 'ActionService', '_handleToggleDrawer', LogTypes.settingsLoad);
  }

  // Selection and Download Handlers
  void _handleSelectItem() {
    // TODO: Implement select current item
    Logger.Inst().log('Select item action triggered', 'ActionService', '_handleSelectItem', LogTypes.settingsLoad);
  }

  void _handleSelectAll() {
    if (_searchHandler.currentTab.booruItems.isNotEmpty) {
      // Clear current selection and add all items
      _searchHandler.currentTab.selected.clear();
      _searchHandler.currentTab.selected.addAll(_searchHandler.currentTab.booruItems);
      
      final context = _navigationHandler.navigatorKey.currentContext;
      if (context != null) {
        FlashElements.showSnackbar(
          context: context,
          title: Text('Selected ${_searchHandler.currentTab.selected.length} items'),
        );
      }
      
      Logger.Inst().log('Select all action triggered - selected ${_searchHandler.currentTab.selected.length} items', 
                        'ActionService', '_handleSelectAll', LogTypes.settingsLoad);
    }
  }

  void _handleClearSelection() {
    _searchHandler.currentTab.selected.clear();
    Logger.Inst().log('Clear selection action triggered', 'ActionService', '_handleClearSelection', LogTypes.settingsLoad);
  }

  void _handleDownloadSelected() {
    if (_searchHandler.currentSelected.isNotEmpty) {
      _snatchHandler.queue(
        _searchHandler.currentSelected,
        _searchHandler.currentBooru,
        _settingsHandler.snatchCooldown,
        false,
      );
      Logger.Inst().log('Download selected action triggered', 'ActionService', '_handleDownloadSelected', LogTypes.settingsLoad);
      
      final context = _navigationHandler.navigatorKey.currentContext;
      if (context != null) {
        FlashElements.showSnackbar(
          context: context,
          title: Text('Started downloading ${_searchHandler.currentSelected.length} items'),
        );
      }
    }
  }

  // Search and Tag Handlers
  void _handleFocusSearch() {
    final context = _navigationHandler.navigatorKey.currentContext;
    if (context != null) {
      // Try to find and focus the search text field
      // This will work if the search field has a global key or focus node
      // For now, we'll show a notification that search focus was triggered
      FlashElements.showSnackbar(
        context: context,
        title: const Text('Search Focus'),
        content: const Text('Search focus shortcut triggered'),
      );
    }
    Logger.Inst().log('Focus search action triggered', 'ActionService', '_handleFocusSearch', LogTypes.settingsLoad);
  }

  void _handleClearSearch() {
    _searchHandler.searchTextController.clear();
    Logger.Inst().log('Clear search action triggered', 'ActionService', '_handleClearSearch', LogTypes.settingsLoad);
  }

  void _handleRefreshSearch() {
    _searchHandler.searchAction(_searchHandler.searchTextController.text, null);
    Logger.Inst().log('Refresh search action triggered', 'ActionService', '_handleRefreshSearch', LogTypes.settingsLoad);
  }

  void _handleToggleFavorite() {
    // TODO: Implement toggle favorite for current item
    Logger.Inst().log('Toggle favorite action triggered', 'ActionService', '_handleToggleFavorite', LogTypes.settingsLoad);
  }

  // UI Control Handlers
  void _handleToggleAppbar() {
    _viewerHandler.toggleToolbar(false);
    Logger.Inst().log('Toggle appbar action triggered', 'ActionService', '_handleToggleAppbar', LogTypes.settingsLoad);
  }

  void _handleToggleBottomBar() {
    // TODO: Implement toggle bottom bar
    Logger.Inst().log('Toggle bottom bar action triggered', 'ActionService', '_handleToggleBottomBar', LogTypes.settingsLoad);
  }

  void _handleToggleNotes() {
    _viewerHandler.showNotes.value = !_viewerHandler.showNotes.value;
    Logger.Inst().log('Toggle notes action triggered', 'ActionService', '_handleToggleNotes', LogTypes.settingsLoad);
  }

  void _handleToggleVideoControls() {
    // TODO: Implement toggle video controls
    Logger.Inst().log('Toggle video controls action triggered', 'ActionService', '_handleToggleVideoControls', LogTypes.settingsLoad);
  }

  /// Dispose of the action service
  void dispose() {
    // Action handlers are automatically unregistered when InputHandler is disposed
    _isInitialized = false;
    Logger.Inst().log('Action service disposed', 'ActionService', 'dispose', LogTypes.settingsLoad);
  }
}
