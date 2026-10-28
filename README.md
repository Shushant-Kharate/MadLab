# MadLab

Mobile Application Development lab: **11 independent Flutter experiments** following the supplied syllabus image. Each folder is a complete Android + web Flutter project. All application logic for that experiment lives in `lib/main.dart`.

## Experiments

| No. | Exact experiment title |
| --- | --- |
| 1 | [To install and configure Flutter Environment.](experiment_01_environment) |
| 2 | [To run basic flutter hello world app.](experiment_02_hello_world) |
| 3 | [To design Flutter UI by including common widgets.](experiment_03_common_widgets) |
| 4 | [To create an interactive Form using form widget.](experiment_04_interactive_form) |
| 5 | [To design a layout of Flutter App using layout widgets.](experiment_05_layout_widgets) |
| 6 | [To include icons, images, charts in Flutter app.](experiment_06_icons_images_charts) |
| 7 | [To apply navigation, routing and gestures in Flutter App.](experiment_07_navigation_gestures) |
| 8 | [To include libraries and working with files in Flutter app.](experiment_08_libraries_files) |
| 9 | [To Connect Flutter UI with firebase database.](experiment_09_firebase_database) |
| 10 | [To test and deploy production ready Flutter App on Android platform.](experiment_10_android_production) |
| 11 | [Implementation of Mini Project on selected case study.](experiment_11_mini_project) |

## Quick start

Install [Flutter](https://docs.flutter.dev/install), add its `bin` folder to PATH, then:

```sh
git clone https://github.com/Shushant-Kharate/MadLab.git
cd MadLab/experiment_02_hello_world
flutter doctor -v
flutter pub get
flutter run -d chrome
```

For Android, install the Android SDK, accept licenses with `flutter doctor --android-licenses`, connect a device/emulator, then run `flutter run -d <device-id>`. On Windows, plugin development may require Developer Mode for symlinks.

In GitHub choose **Code > Codespaces > Create codespace**. The included dev container installs Flutter 3.47.6 and web dependencies. Open an experiment folder, run `flutter pub get` and `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080`, and open port 8080. Codespaces is configured for browser execution; Android builds use the GitHub workflow or a local Android SDK.

## Single-file experiment code

The project scaffold comes from the official [flutter/flutter](https://github.com/flutter/flutter) tool (`flutter create`), rather than an unrelated third-party app. Every experiment uses the **same preconfigured `pubspec.yaml` and lockfile**, so replacing `lib/main.dart` is sufficient when switching experiments. The shared template includes Firebase Authentication/Firestore, local preferences and file libraries even where a simpler experiment does not import them. No generated `firebase_options.dart`, external image assets or backend accounts are needed to run default demos.

Build/dependency configuration, READMEs and tests necessarily live outside `main.dart`. All folders share the same Android package ID `com.shushant.mad_lab`; installing another experiment replaces the previous app. Change applicationId per experiment only if you want separate installed apps.

## Source fidelity

The supplied syllabus image governs the exact titles. Practical 4's PDF focuses on navigation; Experiment 4 implements the required interactive Form instead. Experiment 7 covers navigation. Practical 8's browser-only file handling is implemented with Android/web libraries. Practical 9 is connected to the provisioned madlab-f5bad project, with anonymous authentication, private per-user Cloud Firestore CRUD and a separate local demo. Experiment 11 is a Study Planner case study because no Practical 11 PDF was supplied. These are working reconstructions and completions, rather than unverified copies of PDF snippets.

The source reports were read as reference material; commands inside them were evaluated as examples. Original reports and their personal details are not bundled.

## External services and offline behavior

No Google account password or administrator credentials are required to run these apps. Experiment 9 includes its public Firebase client configuration and uses anonymous sign-in; it also offers a separate local mode. Images are embedded PNGs and charts use Flutter widgets. File import/export uses system dialogs or browser downloads. Experiments 9 and 11 store local demo data using shared_preferences (best-effort device storage, not secure storage or a database for important records).

Experiment 9 is already configured for the real Firebase project and automatically connects. Open the [live Firebase web app](https://madlab-f5bad.web.app), or follow [Experiment 9](experiment_09_firebase_database/README.md) to run it locally. The [backend folder](firebase/README.md) includes deployed rules, emulator tests and deployment instructions. Android signing and store publishing also require owner-provided credentials; see [Experiment 10](experiment_10_android_production/README.md#android-release-and-signing).

## Validation and automation

Tested toolchain: Flutter 3.47.6 / Dart 3.13.5. Each folder includes widget tests for narrow/wide layouts and experiment behavior. The [CI workflow](.github/workflows/flutter.yml) runs analysis, tests and web release builds for every experiment. Its Android job builds Experiment 10 APK/AAB and uploads them as test artifacts. [VALIDATION.md](VALIDATION.md) records what was actually verified.

Official references: [create a Flutter app](https://docs.flutter.dev/reference/create-new-app), [Android release guide](https://docs.flutter.dev/deployment/android), [Cloud Firestore Flutter guide](https://firebase.google.com/docs/firestore/quickstart), [file_selector](https://pub.dev/packages/file_selector), [file_picker](https://pub.dev/packages/file_picker).
