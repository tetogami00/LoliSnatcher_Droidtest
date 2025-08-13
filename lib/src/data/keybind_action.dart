/// Enum defining all possible actions that can be bound to keys/controller buttons
enum KeybindAction {
  // Media Controls
  playPause('Play/Pause', 'Toggle play/pause for videos'),
  seekForward('Seek Forward', 'Seek video forward'),
  seekBackward('Seek Backward', 'Seek video backward'),
  volumeUp('Volume Up', 'Increase video volume'),
  volumeDown('Volume Down', 'Decrease video volume'),
  fastForward('Fast Forward', 'Fast forward video'),
  
  // Navigation
  nextImage('Next Image', 'Go to next image/video'),
  previousImage('Previous Image', 'Go to previous image/video'),
  openViewer('Open Viewer', 'Open current item in full viewer'),
  closeViewer('Close Viewer', 'Close the viewer'),
  
  // Gallery Controls
  zoomIn('Zoom In', 'Zoom into current image'),
  zoomOut('Zoom Out', 'Zoom out of current image'),
  resetZoom('Reset Zoom', 'Reset image zoom to fit'),
  toggleFullscreen('Toggle Fullscreen', 'Toggle fullscreen mode'),
  
  // App Navigation
  nextTab('Next Tab', 'Switch to next tab'),
  previousTab('Previous Tab', 'Switch to previous tab'),
  openSettings('Open Settings', 'Open settings page'),
  openSearch('Open Search', 'Open search page'),
  toggleDrawer('Toggle Drawer', 'Open/close navigation drawer'),
  
  // Selection and Downloads
  selectItem('Select Item', 'Select/deselect current item'),
  selectAll('Select All', 'Select all visible items'),
  clearSelection('Clear Selection', 'Clear all selections'),
  downloadSelected('Download Selected', 'Download all selected items'),
  
  // Search and Tags
  focusSearch('Focus Search', 'Focus on search input'),
  clearSearch('Clear Search', 'Clear current search'),
  refreshSearch('Refresh Search', 'Refresh current search results'),
  toggleFavorite('Toggle Favorite', 'Add/remove from favorites'),
  
  // UI Controls
  toggleAppbar('Toggle Appbar', 'Show/hide top navigation bar'),
  toggleBottomBar('Toggle Bottom Bar', 'Show/hide bottom bar'),
  toggleNotes('Toggle Notes', 'Show/hide image notes'),
  toggleVideoControls('Toggle Video Controls', 'Show/hide video controls');

  const KeybindAction(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Get the action category for grouping in UI
  KeybindCategory get category {
    switch (this) {
      case KeybindAction.playPause:
      case KeybindAction.seekForward:
      case KeybindAction.seekBackward:
      case KeybindAction.volumeUp:
      case KeybindAction.volumeDown:
      case KeybindAction.fastForward:
        return KeybindCategory.media;
      
      case KeybindAction.nextImage:
      case KeybindAction.previousImage:
      case KeybindAction.openViewer:
      case KeybindAction.closeViewer:
        return KeybindCategory.navigation;
      
      case KeybindAction.zoomIn:
      case KeybindAction.zoomOut:
      case KeybindAction.resetZoom:
      case KeybindAction.toggleFullscreen:
        return KeybindCategory.gallery;
      
      case KeybindAction.nextTab:
      case KeybindAction.previousTab:
      case KeybindAction.openSettings:
      case KeybindAction.openSearch:
      case KeybindAction.toggleDrawer:
        return KeybindCategory.appNavigation;
      
      case KeybindAction.selectItem:
      case KeybindAction.selectAll:
      case KeybindAction.clearSelection:
      case KeybindAction.downloadSelected:
        return KeybindCategory.selection;
      
      case KeybindAction.focusSearch:
      case KeybindAction.clearSearch:
      case KeybindAction.refreshSearch:
      case KeybindAction.toggleFavorite:
        return KeybindCategory.search;
      
      case KeybindAction.toggleAppbar:
      case KeybindAction.toggleBottomBar:
      case KeybindAction.toggleNotes:
      case KeybindAction.toggleVideoControls:
        return KeybindCategory.ui;
    }
  }
}

/// Categories for organizing keybind actions
enum KeybindCategory {
  media('Media Controls'),
  navigation('Navigation'),
  gallery('Gallery Controls'),
  appNavigation('App Navigation'),
  selection('Selection & Downloads'),
  search('Search & Tags'),
  ui('UI Controls');

  const KeybindCategory(this.displayName);

  final String displayName;
}
