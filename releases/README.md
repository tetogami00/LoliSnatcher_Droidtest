# LoliSnatcher APK Releases

This directory contains pre-built APK files for the LoliSnatcher Android application.

## Download Guide

### Architecture Selection
Choose the APK that matches your device architecture:

- **arm64-v8a**: Modern 64-bit ARM devices (recommended for most Android phones and tablets made after 2017)
- **armeabi-v7a**: Older 32-bit ARM devices (Android phones and tablets made before 2017)
- **x86_64**: Intel-based Android devices and emulators

### Build Types

- **debug**: Development builds with debug symbols (larger file size)
- **testing**: Testing builds optimized for QA and beta testing
- **github**: Release builds optimized for general distribution
- **store**: Builds configured for app store distribution (AAB format)

## Installation Instructions

1. **Enable Unknown Sources**: Go to Settings > Security > Unknown Sources and enable installation from unknown sources
2. **Download**: Download the appropriate APK file for your device architecture
3. **Install**: Tap on the downloaded APK file and follow the installation prompts
4. **Grant Permissions**: The app may request various permissions for full functionality

## File Naming Convention

APK files follow this naming pattern:
```
LoliSnatcher_<version>_<build>_<architecture>_<buildtype>.apk
```

Example: `LoliSnatcher_2.4.4_4202_arm64-v8a_debug.apk`
- Version: 2.4.4
- Build: 4202
- Architecture: arm64-v8a
- Build Type: debug

## Automated Builds

APKs are automatically built using GitHub Actions when:
- Code is pushed to main branches
- Pull requests are created
- Releases are tagged
- Manual workflow dispatch is triggered

## Git LFS

Due to the large size of APK files (>100MB), this repository uses Git LFS (Large File Storage) to manage them efficiently. If you're cloning this repository and need the APK files, make sure to:

```bash
git lfs pull
```

## File Sizes

Current APK sizes:
- arm64-v8a: ~136MB (debug) / ~30-40MB (release)
- armeabi-v7a: ~110MB (debug) / ~25-35MB (release)  
- x86_64: ~130MB (debug) / ~35-45MB (release)

Debug builds are significantly larger than release builds due to debug symbols and unoptimized code.

## Support

For issues with APK installation or functionality, please check:
1. Device compatibility (Android 6.0+ / API level 23+)
2. Available storage space (at least 200MB free)
3. Architecture compatibility
4. App permissions

Report issues at: [GitHub Issues](../../issues)