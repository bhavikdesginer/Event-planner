# eventhub

Event Booking App

## Firebase Keys Setup

This app expects Firebase API keys from compile-time defines (not committed in source).

1. Copy `.secrets/firebase_keys.example.json` to `.secrets/firebase_keys.json`.
2. Replace `REPLACE_ME` values with your real keys.
3. Run the app with:

```bash
flutter run --dart-define-from-file=.secrets/firebase_keys.json
```

For release builds, pass the same flag to `flutter build ...` commands.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
