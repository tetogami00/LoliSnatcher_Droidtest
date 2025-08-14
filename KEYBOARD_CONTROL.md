# Keyboard Control Feature Documentation

## Overview

The keyboard control feature adds comprehensive keyboard shortcuts to LoliSnatcher, allowing users to navigate, control media, and access information using customizable keybinds.

## Features

### Default Keybinds

| Key | Action | Description |
|-----|--------|-------------|
| `→` (Right Arrow) | Next Post | Navigate to the next post |
| `←` (Left Arrow) | Previous Post | Navigate to the previous post |
| `↑` (Up Arrow) | Zoom In | Zoom in on the current image (double-tap zoom) |
| `↓` (Down Arrow) | Zoom Out | Reset zoom level |
| `Space` | Play/Pause | Toggle video playback |
| `M` | Mute/Unmute | Toggle video audio |
| `+` (Equal) | Volume Up | Increase video volume |
| `-` (Minus) | Volume Down | Decrease video volume |
| `D` | Skip Video Forward | Skip video forward by 5 seconds |
| `I` | Show Info | Display current post information |
| `T` | Show Tags | Display current post tags |
| `H` | Toggle UI | Show/hide the interface toolbar |
| `F` | Toggle Fullscreen | Enter/exit fullscreen mode |
| `Esc` | Exit Fullscreen | Exit fullscreen mode |

### Settings

- **Enable/Disable**: Keyboard control can be toggled on/off in Settings > Keyboard
- **Customizable Keybinds**: All shortcuts can be reassigned to different keys
- **Persistent**: Custom keybinds are saved and restored between app sessions

## Usage

### Gallery View
- Use arrow keys to navigate between posts
- Press `I` to see detailed information about the current post (URLs, file size, resolution)
- Press `T` to view all tags associated with the current post
- Use `H` to hide/show the toolbar for distraction-free viewing

### Video Control
- `Space` to play/pause videos
- `M` to mute/unmute
- `+`/`-` to adjust volume
- `D` to skip forward 5 seconds in the video
- Arrow keys also work for zoom control on videos

### Customization
1. Go to Settings > Keyboard
2. Click "Record" next to any action
3. Press the desired key to assign it
4. Use "Reset to defaults" to restore original keybinds

## Technical Implementation

### Architecture
- **KeyboardHandler**: Main service managing keybinds and event handling
- **Settings Integration**: Keybinds stored in `SettingsHandler` for persistence
- **Event System**: Stream-based architecture for keyboard events
- **Focus Management**: Proper focus handling in gallery view

### File Structure
```
lib/src/handlers/keyboard_handler.dart      # Core keyboard handling logic
lib/src/pages/settings/keyboard_page.dart   # Settings UI for keybind customization
lib/src/handlers/settings_handler.dart      # Modified to store keyboard settings
lib/src/handlers/viewer_handler.dart        # Extended with media control methods
lib/src/pages/gallery_view_page.dart        # Integrated keyboard event handling
```

### Key Classes
- `KeyboardHandler`: Manages keybinds, handles events, executes actions
- `KeyboardAction`: Enum defining all available actions
- `KeyboardSettingsPage`: UI for customizing keybinds

## Testing

Basic unit tests verify:
- Key display name formatting
- Action descriptions and names
- Static methods functionality

Run tests with:
```bash
flutter test test/keyboard_handler_test.dart
```

## Future Enhancements

Potential improvements could include:
- Modifier key support (Ctrl+Key, Alt+Key)
- Configurable repeat rates for navigation
- Context-sensitive keybinds (different binds for different screens)
- Import/export of keybind configurations
- Visual indicators for available shortcuts