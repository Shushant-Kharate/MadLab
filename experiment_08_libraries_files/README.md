# Experiment 08: Libraries and file handling

**Exact syllabus title:** To include libraries and working with files in Flutter app.

## Aim and theory

Dart UTF-8 encoding, typed byte data, file_selector import, file_picker Android export and browser download. Imports .txt/.csv/.json, shows name/size/content, edits, exports and clears.

Flutter composes widgets to describe the UI. StatefulWidget and setState rebuild the UI when input changes; the relevant layout, input, navigation or storage API is demonstrated in `lib/main.dart`.

## Run independently

Open **this folder**, not the repository root, in VS Code or Android Studio.

```sh
flutter pub get
flutter run -d chrome
# Android: start an emulator or connect a USB-debugging device
flutter devices
flutter run -d <android-device-id>
```

In Codespaces use `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080`, then open forwarded port 8080.

## Implementation

All experiment application logic is in [lib/main.dart](lib/main.dart). Android and web folders are the official Flutter scaffold, with shared dependencies preconfigured. The same `main.dart` can be copied into any other experiment folder here.

Replaces the PDF web-only dart:html implementation with APIs that compile on Android and web. Native dialogs require a real device/browser and user interaction.

## Verify

```sh
flutter analyze
flutter test
flutter build web --release
```

Manual acceptance: Import a small UTF-8 file, edit/export it and reopen the result. Cancel dialogs; try invalid UTF-8 and a file over 1 MB.

Expected result: the behavior described above works without a backend account in default mode. Dependency installation and the first Flutter web engine download need internet. See the root [validation record](../VALIDATION.md) for checks actually performed.
