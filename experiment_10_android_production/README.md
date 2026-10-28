# Experiment 10: Android testing and release

**Exact syllabus title:** To test and deploy production ready Flutter App on Android platform.

## Aim and theory

Material 3, light/dark system theme, safe layout, counter/reset, recoverable error demo, framework/platform error handlers, friendly error UI, tests, release build workflow and signing instructions.

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

App code alone cannot install Android SDKs, provide signing keys or publish to Play. The repository includes the necessary build instructions and opt-in release signing configuration.

## Verify

```sh
flutter analyze
flutter test
flutter build web --release
```

Manual acceptance: Run tests, build a release APK/AAB, install on an Android device, verify theme, rotation, back navigation, counter and error recovery.

Expected result: the behavior described above works without a backend account in default mode. Dependency installation and the first Flutter web engine download need internet. See the root [validation record](../VALIDATION.md) for checks actually performed.

## Android release and signing

The app demonstrates runtime recovery and both framework/platform error hooks. Logs currently go to debugPrint; attach a monitoring service before a real release. The **Test recovery** button tests a handled failure; it does not deliberately crash the app.

Run `flutter doctor -v`, install Android SDK tools, and accept licenses. Use JDK 17 or 21. Then:

```sh
flutter analyze
flutter test
flutter run --release -d <android-device-id>
flutter build apk --release
flutter build appbundle --release
```

APK: `build/app/outputs/flutter-apk/app-release.apk`.
AAB: `build/app/outputs/bundle/release/app-release.aab`.

Without signing environment variables, the scaffold uses a debug signing key so lab release builds are installable. Those builds are **not Play Store submissions**. The optional signing block supports a real upload key without committing it:

```sh
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
# Set these in your shell or CI secret environment; do not commit their values:
# MADLAB_STORE_FILE = absolute path to your keystore
# MADLAB_STORE_PASSWORD = keystore password
# MADLAB_KEY_ALIAS = upload
# MADLAB_KEY_PASSWORD = key password
flutter build appbundle --release --build-name=1.0.0 --build-number=1
```

Release checklist: choose a unique applicationId and app name, use an upload key and Play App Signing, verify permissions and dependency requirements, test on supported Android versions/screen sizes in release mode, test dark theme/rotation/accessibility/back handling, check startup and error recovery, replace diagnostic logs with reporting, prepare privacy/data disclosures and store listing, then upload the signed AAB to Play Console internal testing. Promotion to production is an owner action after device testing. No store deployment has been performed by this repository.
