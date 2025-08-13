# Meta Quest 3 Controller Support for LoliSnatcher

This implementation adds full compatibility with the Meta Quest 3, enabling controller input even when the cursor is outside the window and allowing users to configure custom keybinds.

## Features

- **Global Input Detection**: Works even when the app window is not focused
- **Configurable Keybinds**: Users can assign any key combination to any action
- **33 Supported Actions**: Covering media controls, navigation, gallery operations, and UI controls
- **Desktop Platform Support**: Available on Windows, Linux, and macOS
- **Conflict Detection**: Prevents duplicate key combinations
- **Persistent Settings**: Keybinds are saved and restored automatically

## How to Use

### Accessing Keybind Settings

1. Open LoliSnatcher on a desktop platform (Windows, Linux, or macOS)
2. Go to **Settings** → **Interface**
3. Scroll down to find **"Keyboard & Controller Settings"**
4. Click to open the keybind configuration page

### Configuring Keybinds

1. In the keybind settings page, actions are organized by category:
   - **Media Controls**: Play/pause, seek, volume control
   - **Navigation**: Next/previous image, viewer controls
   - **Gallery Controls**: Zoom, fullscreen
   - **App Navigation**: Tab switching, settings, search
   - **Selection & Downloads**: Item selection, downloading
   - **Search & Tags**: Search operations, favorites
   - **UI Controls**: Toggle interface elements

2. To set a keybind:
   - Click the **Edit** button (pencil icon) next to any action
   - Press the desired key combination (e.g., `Ctrl + Space`, `F1`, `Alt + Right`)
   - The keybind will be saved automatically

3. To remove a keybind:
   - Click the **Clear** button (X icon) next to the action

4. To reset all keybinds to defaults:
   - Click the **Reset** button in the top-right corner

### Default Keybinds

The system comes with sensible default keybinds:

| Action | Default Keybind |
|--------|----------------|
| Play/Pause | `Space` |
| Seek Forward | `Right Arrow` |
| Seek Backward | `Left Arrow` |
| Next Image | `Ctrl + Right` |
| Previous Image | `Ctrl + Left` |
| Open Viewer | `Enter` |
| Close Viewer | `Escape` |
| Zoom In | `Ctrl + =` |
| Zoom Out | `Ctrl + -` |
| Reset Zoom | `Ctrl + 0` |
| Toggle Fullscreen | `F11` |
| Next Tab | `Ctrl + Tab` |
| Previous Tab | `Ctrl + Shift + Tab` |
| Open Settings | `Ctrl + ,` |
| Select All | `Ctrl + A` |
| Download Selected | `Ctrl + S` |
| Refresh Search | `F5` |

## Quest 3 Integration

### Using Quest Link/Air Link

1. Connect your Quest 3 to your PC via Quest Link or Air Link
2. Open LoliSnatcher in desktop mode on your PC
3. Put on your Quest 3 headset and use the virtual desktop
4. The configured keybinds will work through the Quest 3 controllers

### Controller Mapping

Quest 3 controllers can be mapped to keyboard inputs using:
- **Meta Quest software**: Built-in keyboard mapping
- **Virtual Desktop**: Controller binding features
- **SteamVR**: Input mapping when running through Steam

### Recommended Bindings for VR

For optimal VR experience, consider these controller mappings:

- **Right Trigger**: Space (Play/Pause)
- **Right Grip**: Enter (Open Viewer)
- **A Button**: Ctrl + Right (Next Image)
- **B Button**: Escape (Close/Back)
- **X Button**: Ctrl + A (Select All)
- **Y Button**: Ctrl + S (Download)
- **Right Thumbstick Click**: F11 (Fullscreen)

## Technical Details

### Architecture

- **InputHandler**: Captures global keyboard input using Flutter's `HardwareKeyboard` API
- **ActionService**: Maps input events to application actions
- **KeybindConfig**: Manages keybind configuration and persistence
- **Settings Integration**: Seamless integration with existing LoliSnatcher settings

### Focus-Independent Input

The system uses Flutter's hardware keyboard listener to capture input even when:
- The application window is not focused
- The user is interacting with other applications
- The cursor is outside the application window

This is essential for VR usage where the virtual desktop may not always have direct focus.

### Supported Modifiers

- `Ctrl` (Control)
- `Shift`
- `Alt`
- `Cmd`/`Meta` (Windows key on PC, Cmd on Mac)

### Data Persistence

Keybind configurations are stored in the application's settings JSON file and automatically loaded on startup.

## Troubleshooting

### Keybinds Not Working

1. **Check Platform**: Keybind support is only available on desktop platforms
2. **Verify Settings**: Ensure keybinds are properly configured in settings
3. **Test Focus**: Try with the application window focused first
4. **Check Conflicts**: Ensure no system shortcuts conflict with your bindings

### Quest 3 Issues

1. **Update Oculus Software**: Ensure Quest Link/Air Link is up to date
2. **Check Virtual Desktop**: Verify keyboard input is working in virtual desktop
3. **Test with Native Apps**: Confirm controller input works in other desktop applications
4. **Restart Services**: Try restarting Quest Link/Air Link connection

### Performance Considerations

- Global input detection has minimal performance impact
- Only enabled on desktop platforms to avoid mobile overhead
- Automatic cleanup when application closes

## Development Notes

### Adding New Actions

To add new actions:

1. Add to `KeybindAction` enum in `keybind_action.dart`
2. Implement handler in `ActionService`
3. Register handler in `_registerActionHandlers()`

### Integration Points

The system integrates with existing LoliSnatcher components:
- `SearchHandler`: Tab management, search operations
- `ViewerHandler`: Image/video viewer controls
- `SnatchHandler`: Download operations
- `SettingsHandler`: Configuration persistence
- `NavigationHandler`: App navigation

This implementation provides a solid foundation for VR and controller-based interaction with LoliSnatcher while maintaining compatibility with traditional desktop usage.