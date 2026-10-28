# Experiment 09: Firebase student records

**Exact syllabus title:** To Connect Flutter UI with firebase database.

## Aim and theory

Validated add/read/delete, persistent local demo, explicitly configured Cloud Firestore mode, live query subscription, loading states, timeouts and error messages.

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

Uses real firebase_core/cloud_firestore, as in the PDF. Local demo is clearly labeled and is not Firebase. Local/cloud data are separate and local records are never automatically uploaded.

## Verify

```sh
flutter analyze
flutter test
flutter build web --release
```

Manual acceptance: Add and delete students; reload to check persistence. With a Firebase test project configured, connect and verify remote CRUD.

Expected result: the behavior described above works without a backend account in default mode. Dependency installation and the first Flutter web engine download need internet. See the root [validation record](../VALIDATION.md) for checks actually performed.

## Real Cloud Firestore

1. Create a Firebase test project and a Cloud Firestore database. Register a web app (for browser execution) or an Android app with package `com.shushant.mad_lab` (for Android execution).
2. Copy the platform app's Firebase options from the console. Start with that platform's values, not placeholders:

```sh
flutter run -d chrome --dart-define=FIREBASE_PROJECT_ID=your-project --dart-define=FIREBASE_API_KEY=your-api-key --dart-define=FIREBASE_APP_ID=your-app-id --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id
```

3. Press **Connect Firebase**. Initialization, a server read and the live `students` collection query must succeed before cloud mode is active. App writes use Firestore server timestamps. Add a student; confirm it in the Firebase console; delete it and confirm its removal.
4. This lab deliberately has no authentication flow. Rules must authorize the requests to your disposable test database. Default locked rules will deny access; this is shown as an error, rather than a fake success. Do not expose real student records or loosen production rules. A deployed product needs Firebase Authentication and scoped rules before remote CRUD is appropriate.

Cloud errors are visible. Failed writes keep the input; use **Switch to local demo** to return to persistent device records. Cloud and local records are never silently mixed. Stream subscriptions and text controllers are disposed. No real Firebase credentials were provided, so remote integration cannot be claimed as verified.
