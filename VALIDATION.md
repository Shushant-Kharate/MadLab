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

Not verified locally: Android APK/AAB compilation (no Android SDK available), Android native file dialogs, a physical-device install, live Cloud Firestore CRUD (no Firebase project credentials), and Play Store publishing. GitHub Actions is configured to compile an Android lab APK/AAB and all web experiments; its results are separate evidence. Release builds without upload signing variables use the debug key and are for lab testing only.
