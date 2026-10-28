# MadLab Firebase backend

The live project is **madlab-f5bad**, with a Standard Firestore database in Mumbai and anonymous Authentication enabled. [Console](https://console.firebase.google.com/project/madlab-f5bad/overview) | [Live app](https://madlab-f5bad.web.app).

## Files

- `firestore.rules`: per-user CRUD permissions and schema validation.
- `firestore.indexes.json`: no custom/composite indexes required; the app orders by one timestamp field.
- `test/firestore.rules.test.mjs`: seven security-rule suites against a demo emulator project.
- `test/live-crud.mjs`: live client verification; creates disposable users/records and removes its own fixtures.
- Root `firebase.json`: rules, hosting and emulator configuration.
- Root `.firebaserc`: dedicated Firebase project selection.

## Reproducible security tests

Requires Node 20+ and Java 21. From this folder:

```sh
npm ci
npm test
```

The emulator project is `demo-madlab`; production Google credentials are not needed for these tests. Expected permission-denied logs are assertions that invalid requests were rejected. The emulator suite verifies owner CRUD, unauthenticated denial, cross-user denial, field validation, required timestamps, immutable creation time and default-deny behavior for other collections.

To repeat the live cloud smoke test against this project's deployed rules:

```sh
node test/live-crud.mjs
```

The live test uses the same public client configuration as the app, not an Admin SDK credential. It checks anonymous sign-in, CRUD and cross-user read denial. It deletes only the fixtures and anonymous accounts it created.

## Deploy an update

First build the Flutter app from `experiment_09_firebase_database`:

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release
```

From this `firebase` folder:

```sh
npm ci
npx firebase login
npx firebase deploy --config ../firebase.json --project madlab-f5bad --only firestore:rules,hosting
```

The Hosting deployment uploads the compiled Experiment 9 app only. It does not publish the other experiments. The web interface is public; Firestore records remain private to their authenticated owner. No service-account key or Google password belongs in the client or repository.

The project remains on Spark. No billing account, paid upgrade, Cloud Functions, paid backups or Storage bucket was enabled for this lab. The configured services use free-plan quotas; exceeding quotas can cause requests to fail. Anonymous auth demonstrates owner isolation, not a complete production identity/recovery system. App Check, recoverable accounts and operational monitoring are future production concerns.
