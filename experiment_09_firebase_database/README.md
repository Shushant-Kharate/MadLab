# Experiment 09: Firebase student records

**Exact syllabus title:** To Connect Flutter UI with firebase database.

## Run

This project is configured for **madlab-f5bad**. No Google account password, service-account file or extra dart defines are required.

```sh
flutter pub get
flutter run -d chrome
# Or connect an Android device/emulator:
flutter run -d <android-device-id>
```

The application automatically connects, signs in anonymously and opens your own student records. [Live web app](https://madlab-f5bad.web.app) | [Firebase console](https://console.firebase.google.com/project/madlab-f5bad/overview).

All Flutter application code and platform-specific public Firebase options are in [lib/main.dart](lib/main.dart). Both web and Android apps are registered with Firebase; the Android package is `com.shushant.mad_lab`. Explicit FirebaseOptions initialize the native app, so this example does not require generated `firebase_options.dart` or the Google Services Gradle plugin.

## Implementation

- Firebase Authentication creates a persistent anonymous identity on this browser/device.
- Firestore stores records at `users/{uid}/students/{studentId}`.
- The UI validates name/email, creates records with server timestamps, streams live updates, edits existing records and confirms deletion.
- Rules allow only the authenticated owner to read/write their records. They validate field names, types, lengths, email format and timestamps. Creation timestamps cannot be changed.
- Loading states disable duplicate actions. Errors remain visible and failed saves preserve the input.
- **Switch to local demo** uses separate shared_preferences records; **Connect Firebase** returns to cloud mode. Connecting never uploads local records automatically.

Anonymous identity is convenient for a self-contained lab. It is tied to the browser/device, and clearing app data loses access to it. It does not provide cross-device sign-in, student roles, administrator access or durable account recovery. Keep important production records behind a recoverable account provider.

## Firebase resources

Project: `madlab-f5bad` (display name MadLab), Spark plan.
Database: `(default)`, Standard edition, native Firestore, `asia-south1` (Mumbai).
Authentication provider: Anonymous.
Hosting: `madlab-f5bad.web.app`.
Cloud records are private to their anonymous owner; the web interface itself is publicly reachable.

Firebase client API keys and app IDs identify the app and are intentionally included in client code. They are not administrator credentials. Security depends on Authentication and [Firestore rules](../firebase/firestore.rules), not on hiding the client configuration. Google passwords, OAuth tokens, service-account private keys and signing keys must never be added to the repository.

## Validate

```sh
flutter analyze
flutter test
flutter build web --release
```

Manual acceptance: add a student, edit the name, reload and confirm the same identity/record, then delete the record and confirm its disappearance. Repeat in local mode to verify cloud/local separation.

The [backend tests](../firebase/README.md) include seven emulator security-rule tests and a live cloud CRUD/isolation smoke test. See [VALIDATION.md](../VALIDATION.md) for executed checks and remaining platform limits.

## Use Firebase emulators

From the repository's `firebase` folder, run `npm ci`, then `npx firebase emulators:start --config ../firebase.json --project demo-madlab --only auth,firestore` (Node 20+ and Java 21 are required).

In this experiment folder:

```sh
flutter run -d chrome --dart-define=FIREBASE_EMULATORS=true
# Android emulator reaches the host through 10.0.2.2:
flutter run -d <android-device-id> --dart-define=FIREBASE_EMULATORS=true --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2
```

Ports: Authentication 9099, Firestore 8081, emulator UI 4000. The project ID is forced to `demo-madlab` in emulator mode, so these tests cannot write to the live project. HTTP emulator traffic is allowed only in the Android debug manifest. The release manifest uses the platform's HTTPS defaults.

## Reconfigure

The following dart defines override the public defaults in main.dart: FIREBASE_PROJECT_ID, FIREBASE_API_KEY (web), FIREBASE_APP_ID (web), FIREBASE_ANDROID_API_KEY, FIREBASE_ANDROID_APP_ID, FIREBASE_MESSAGING_SENDER_ID and FIREBASE_AUTH_DOMAIN. Register both platform apps, enable anonymous sign-in, and deploy the supplied rules to any replacement project. Do not point this lab at an unrelated existing database.
