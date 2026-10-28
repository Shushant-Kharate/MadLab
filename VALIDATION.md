# Validation record

Date: 28 October 2026 (Asia/Kolkata). Toolchain: Flutter 3.47.6 / Dart 3.13.5, Windows host.

| Experiment | Static analysis | Widget tests | Web release compilation |
| --- | --- | --- | --- |
| experiment_01_environment | PASS | PASS | PASS |
| experiment_02_hello_world | PASS | PASS | PASS |
| experiment_03_common_widgets | PASS | PASS | PASS |
| experiment_04_interactive_form | PASS | PASS | PASS |
| experiment_05_layout_widgets | PASS | PASS | PASS |
| experiment_06_icons_images_charts | PASS | PASS | PASS |
| experiment_07_navigation_gestures | PASS | PASS | PASS |
| experiment_08_libraries_files | PASS | PASS | PASS |
| experiment_09_firebase_database | PASS | PASS | PASS |
| experiment_10_android_production | PASS | PASS | PASS |
| experiment_11_mini_project | PASS | PASS | PASS |

Each test suite has a responsive smoke test at 360 px and 1200 px plus an experiment behavior test: 22 tests in total. Tests use mocked shared_preferences storage; they do not prove native plugin execution.

Browser verification: opened compiled Hello World and file-handling releases. In Experiment 8 entered `MAD Lab file round trip`, downloaded `madlab-notes.txt`, then selected the downloaded file and verified successful import with its 23-byte length and original content. [Screenshot](docs/file-roundtrip.png).

Corrections from testing: expanded the registration dropdown to prevent narrow-screen overflow; adjusted off-screen chart testing to scroll the list; allowed the single-tap timeout when double-tap detection is present; resolved analyzer lint findings.

Not verified locally: Android APK/AAB compilation (no Android SDK available), Android native file dialogs, a physical-device install, and Play Store publishing. GitHub Actions is configured to compile an Android lab APK/AAB and all web experiments; its results are separate evidence. Release builds without upload signing variables use the debug key and are for lab testing only.

## GitHub Actions result

The first two workflow runs were rejected before any runner steps executed. GitHub check annotation: "The job was not started because recent account payments have failed or your spending limit needs to be increased. Please check the Billing & plans section in your settings."

This is an account-level runner availability restriction, not a compiler/test failure. [Run evidence](https://github.com/Shushant-Kharate/MadLab/actions/runs/40735761711). After resolving the GitHub account restriction, rerun the workflow to obtain the Android build artifacts. No payment or account billing settings were changed.

## Completed Firebase integration

The entire Flutter matrix above was rerun after adding Firebase Authentication to the shared dependency template: all 11 analyses, 22 widget tests and 11 web release builds passed.

Project `madlab-f5bad` is provisioned on Spark, with a Standard native Firestore database in `asia-south1` (Mumbai), Anonymous Authentication, registered Android/web apps, deployed rules and [Firebase Hosting](https://madlab-f5bad.web.app). The Android Firebase options are configured in main.dart; a physical Android run is still unverified because no Android SDK/device is available here.

Executed backend checks:

- `npm test` in firebase/: seven emulator rule tests passed. They exercise owner CRUD, unauthenticated/cross-user denial, input schema validation, timestamp constraints and default-deny behavior.
- `node test/live-crud.mjs`: passed against the real Firebase project using only client authentication; verified anonymous sign-in, create/read/update/delete, server timestamps and cross-user read denial. Its disposable users and records were removed.
- Deployed Flutter UI: automatic cloud connection; created a disposable student; reloaded and verified the same anonymous UID and persisted record; edited the record; confirmed deletion and verified an empty list; switched to local mode and reconnected successfully. [Screenshot of the verified cloud record](docs/firebase-live.png). The UI test record was removed after the screenshot.
- Firebase CLI successfully deployed the same tested rules and compiled Experiment 9 web application to Hosting.

Google account passwords and OAuth/service-account secrets are not stored in the repository. The public Firebase app configuration is included as required by the client SDK. Cloud records are isolated by user UID; clearing browser/app data loses access to an anonymous identity.
