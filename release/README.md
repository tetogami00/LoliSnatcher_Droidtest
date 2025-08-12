# LoliSnatcher Release Files

This folder contains the built APK and AAB files for LoliSnatcher v2.4.4 build 4202.

## APK Files

All APK files are under 100MB and ready to use:

### Testing Build (Debug signed)
- `LoliSnatcher_2.4.4_4202_arm64-v8a_test.apk` (58MB) - For 64-bit ARM devices (most modern Android devices)
- `LoliSnatcher_2.4.4_4202_armeabi-v7a_test.apk` (51MB) - For 32-bit ARM devices (older Android devices)  
- `LoliSnatcher_2.4.4_4202_x86_64_test.apk` (66MB) - For Intel 64-bit devices (emulators, some tablets)

### GitHub Build (Release optimized)
- `LoliSnatcher_2.4.4_4202_arm64-v8a_github.apk` (58MB) - For 64-bit ARM devices
- `LoliSnatcher_2.4.4_4202_armeabi-v7a_github.apk` (51MB) - For 32-bit ARM devices
- `LoliSnatcher_2.4.4_4202_x86_64_github.apk` (66MB) - For Intel 64-bit devices

## AAB File (Split Archive)

The Store build AAB file was 114MB, exceeding GitHub's 100MB file size limit, so it has been split into parts:

### Store Build (Play Store ready)
- `LoliSnatcher_2.4.4_4202_appbundle_store.aab.partaa` (90MB) - Part 1 of split file
- `LoliSnatcher_2.4.4_4202_appbundle_store.aab.partab` (24MB) - Part 2 of split file

#### To reconstruct the AAB file:
```bash
# Combine the split files (requires both files in same directory)
cat LoliSnatcher_2.4.4_4202_appbundle_store.aab.part* > LoliSnatcher_2.4.4_4202_appbundle_store.aab
# This will recreate the original AAB file for Play Store upload
```

## Installation Instructions

### For Android Devices:
1. Download the appropriate APK for your device architecture
2. Enable "Unknown Sources" in Android settings  
3. Install the APK file

### For Play Store Upload:
1. Download both split archive files (z01 and zip)
2. Extract as shown above to get the AAB file
3. Upload the AAB file to Google Play Console

## Build Information

- **Version**: 2.4.4
- **Build Number**: 4202
- **Flutter Version**: 3.32.8
- **Built on**: August 12, 2025
- **Target SDK**: Android 35
- **Minimum SDK**: Android 23 (Android 6.0)

## Architecture Support

- **arm64-v8a**: 64-bit ARM (most modern devices like Samsung Galaxy, Google Pixel, etc.)
- **armeabi-v7a**: 32-bit ARM (older devices)
- **x86_64**: Intel 64-bit (Android emulators, Intel-based tablets)