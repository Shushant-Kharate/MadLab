# Experiment 06: Icons, offline image and chart

**Exact syllabus title:** To include icons, images, charts in Flutter app.

## Aim and theory

Material icons, embedded PNG Image.memory and a labeled, accessible animated bar chart with alternate data.

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

Uses native widgets for charts as in the PDF; no chart service or network image is required.

## Verify

```sh
flutter analyze
flutter test
flutter build web --release
```

Manual acceptance: Verify all three visual types appear with networking disabled; change the chart data.

Expected result: the behavior described above works without a backend account in default mode. Dependency installation and the first Flutter web engine download need internet. See the root [validation record](../VALIDATION.md) for checks actually performed.
