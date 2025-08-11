# LoliSnatcher Droid Development Instructions

LoliSnatcher Droid is a Flutter application for browsing and batch downloading images from various booru sites. The app supports Android, Linux, and Windows platforms and uses Flutter Version Manager (FVM) for consistent Flutter version management.

**ALWAYS follow these instructions first and fallback to additional search and context gathering only if the information here is incomplete or found to be in error.**

## Working Effectively

### Initial Setup
Run these commands to bootstrap and set up the development environment:

1. **Install Flutter and FVM**:
   ```bash
   # Install FVM (Flutter Version Manager)
   curl -fsSL https://fvm.app/install.sh | bash
   
   # If fvm.app is unreachable, install via dart pub:
   dart pub global activate fvm
   
   # If Dart is not available, install Flutter manually:
   git clone https://github.com/flutter/flutter.git /opt/flutter
   export PATH="/opt/flutter/bin:$PATH"
   flutter --version
   ```

2. **Set up project with FVM**:
   ```bash
   cd [project-root]
   # Install Flutter 3.32.8 via FVM (as specified in .fvmrc)
   fvm install 3.32.8
   fvm use 3.32.8
   
   # If FVM fails, use Flutter directly:
   flutter channel stable
   flutter upgrade
   ```

3. **Generate configuration and install dependencies**:
   ```bash
   # Generate empty secrets configuration
   sh gen_config.sh
   
   # Install project dependencies - NEVER CANCEL: Takes 5-10 minutes
   # Project has 100+ dependencies including 6 git-based packages
   fvm flutter pub get
   # OR if using Flutter directly:
   flutter pub get
   ```

### Build Process
Use the custom build script which handles different deployment targets:

```bash
# Interactive build selection
./build.sh

# Direct build commands:
./build.sh testing    # For development/testing
./build.sh github     # For GitHub releases  
./build.sh store      # For Play Store (AAB format)
```

**NEVER CANCEL**: Build process takes 20-35 minutes depending on configuration. Set timeout to 60+ minutes.

**Build timing expectations** (for 60k+ lines of code with many dependencies):
- Testing build: ~20 minutes (APK with architecture splits)
- GitHub build: ~25 minutes (Release APK with splits)
- Store build: ~35 minutes (AAB format for Play Store)

### Testing
Run the comprehensive test suite:

```bash
# Run all tests - NEVER CANCEL: Takes 10-15 minutes
fvm flutter test
# OR:
flutter test

# Run specific test file:
fvm flutter test test/booru_test.dart
```

**NEVER CANCEL**: Test suite takes 15-20 minutes to complete as it tests multiple booru handlers and network endpoints. Set timeout to 40+ minutes.

### Development Workflow
For active development with hot reload:

```bash
# Start development server - NEVER CANCEL: Compilation takes 5-10 minutes initially
fvm flutter run
# OR:
flutter run

# For debugging specific build configurations:
fvm flutter run --dart-define=LS_IS_TESTING=true --dart-define-from-file=./config/secrets.json
```

**NEVER CANCEL**: Initial compilation and device setup takes 8-15 minutes. Set timeout to 30+ minutes.

## Validation

### Manual Validation Requirements
After making changes, ALWAYS run through these validation scenarios:

1. **Basic App Functionality**:
   - Launch the app successfully (should show main screen within 30 seconds)
   - Navigate through main screens (search, settings, downloads)
   - Test image loading from at least one booru source (e.g., safebooru.org)
   - Verify batch download functionality works
   - Test settings persistence and app restart

2. **Build Validation**:
   - Test build succeeds for your target configuration
   - Verify APK/AAB file is generated correctly in build/app/outputs/
   - Check app installs and runs on target platform
   - For testing builds: Verify 3 APK files are generated (arm64-v8a, armeabi-v7a, x86_64)
   - For store builds: Verify single AAB file is generated

3. **Code Quality Validation**:
   ```bash
   # Run linter - REQUIRED before committing
   fvm flutter analyze
   
   # Format code - REQUIRED before committing  
   fvm flutter format .
   
   # Check for additional issues
   fvm dart fix --apply
   ```

4. **Network and API Validation**:
   - Test at least 3 different booru sources from the test suite
   - Verify image thumbnails load correctly
   - Test search functionality with basic queries
   - Validate download progress and completion

### VSCode Development
The project includes pre-configured VSCode settings:

- **Launch configurations**: Use F5 to run with different build modes
- **Tasks**: Pre-launch task automatically generates secrets config
- **Settings**: Dart formatting and linting configured for 120-character lines

Access via Command Palette:
- `Flutter: Launch Emulator`
- `Flutter: Select Device`
- `Dart: Use Recommended Settings`

## Build Configurations

### Testing Build (`LS_IS_TESTING=true`)
- Includes debug symbols and testing features
- Generates architecture-specific APKs
- Used for development and QA testing

### GitHub Build (`LS_IS_STORE=false`)  
- Release optimized without store-specific restrictions
- Generates architecture-specific APKs
- Used for GitHub releases and sideloading

### Store Build (`LS_IS_STORE=true`)
- Play Store compliant configuration
- Generates single AAB (Android App Bundle)
- Required for Play Store submissions

## Project Structure

### Key Directories
- `lib/src/` - Main application source code
  - `boorus/` - Booru site handlers and API implementations
  - `data/` - Data models and structures
  - `handlers/` - Core application logic handlers
  - `pages/` - UI screens and widgets
  - `services/` - Background services and utilities
  - `utils/` - Helper functions and utilities
  - `widgets/` - Reusable UI components

### Important Files
- `.fvmrc` - Flutter version specification (3.32.8)
- `build.sh` - Custom build script with target selection
- `gen_config.sh` - Generates empty secrets configuration
- `pubspec.yaml` - Project dependencies and metadata
- `analysis_options.yaml` - Strict linting and formatting rules
- `test/booru_test.dart` - Comprehensive booru handler tests

## Common Issues and Solutions

### Network/Connectivity Issues
If you encounter download failures during `flutter pub get`:
```bash
# Clear Flutter cache and retry
flutter clean
fvm flutter pub get

# For persistent issues, configure proxy if needed
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port

# Alternative: Use --offline flag if packages are cached
flutter pub get --offline
```

### Build Failures
```bash
# Clean build cache completely
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Regenerate configuration
sh gen_config.sh

# Retry build
./build.sh [target]

# If Gradle issues occur:
cd android && ./gradlew clean && cd ..
```

### Test Failures
- Booru tests may fail due to network connectivity or site changes
- Image loading tests are disabled by default (`runWithImages = false`)
- Test timeouts are normal for network-dependent tests
- Individual booru handler failures don't indicate code issues

### FVM Issues
```bash
# If FVM fails to install Flutter version:
fvm install 3.32.8 --skip-setup

# If FVM commands fail, fall back to direct Flutter:
export PATH="/path/to/flutter/bin:$PATH"
flutter channel stable
flutter upgrade

# Check Flutter installation:
flutter doctor -v
```

### VSCode Issues
```bash
# If Dart/Flutter extensions don't work:
# 1. Ensure Flutter SDK path is configured in VSCode settings
# 2. Reload VSCode window (Ctrl+Shift+P -> "Developer: Reload Window")
# 3. Run "Flutter: Change SDK" command if needed
```

## Critical Reminders

- **NEVER CANCEL** long-running commands (builds, tests, pub get)
- **ALWAYS** run `flutter analyze` and `flutter format .` before committing
- **ALWAYS** test basic app functionality after code changes
- **REQUIRED**: Use the custom build script for production builds
- **REQUIRED**: Generate secrets config before building or debugging
- Set timeouts of 60+ minutes for builds, 40+ minutes for tests, 30+ minutes for initial runs

## Dependencies Management

The project uses many git-based dependencies. When updating:
```bash
# Update specific dependency
fvm flutter pub upgrade package_name

# Update all dependencies (use with caution)
fvm flutter pub upgrade

# Check for outdated dependencies
fvm flutter pub outdated
```

## Quick Reference Commands

### Essential Daily Commands
```bash
# Setup (run once)
sh gen_config.sh
fvm flutter pub get

# Development
fvm flutter run                    # Start with hot reload
fvm flutter analyze               # Lint code  
fvm flutter format .              # Format code
fvm flutter test                  # Run tests

# Building
./build.sh testing               # Development build
./build.sh github                # Release build
./build.sh store                 # Play Store build

# Cleanup
flutter clean                    # Clear build cache
```

### File Locations to Know
- `config/secrets.json` - Generated configuration (git ignored)
- `build/app/outputs/flutter-apk/` - APK output location
- `build/app/outputs/bundle/release/` - AAB output location  
- `lib/src/handlers/` - Core application logic
- `lib/src/boorus/` - Site-specific API handlers
- `test/booru_test.dart` - Main test suite

## Platform-Specific Notes

### Android SDK Requirements
Before building, ensure Android SDK is configured:

```bash
# Required Android SDK components
# - Android SDK 23+ (minimum supported)
# - Android SDK 35 (compile target)
# - NDK 27.2.12479018
# - Java 17+

# Check requirements:
flutter doctor -v

# Install missing Android components via Android Studio
# or command line tools
```

### Architecture Support
- **arm64-v8a**: Primary 64-bit ARM architecture (most modern devices)
- **armeabi-v7a**: 32-bit ARM architecture (older devices)
- **x86_64**: Intel 64-bit architecture (emulators, some tablets)

### Linux/Windows  
- Desktop support enabled in Flutter 3.32.8
- Build support available but may require additional setup
- Primary focus is Android development
- Primary focus is Android development
- Primary focus is Android development