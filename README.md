# SafariWorld

A South African safari companion app built with Flutter. Helps safari-goers
identify animals, log sightings, find the nearest national park with
turn-by-turn directions, and reach park emergency contacts — all from one
app.

## Features

- **Animal Guide** — facts on Africa's iconic safari animals (diet, habitat,
  lifespan, conservation status, fun facts).
- **Log a Sighting** — record animals spotted, with a tap-to-reveal
  checklist of species.
- **Safari Map** — uses your device location to find the nearest national
  park and opens turn-by-turn directions to its main gate.
- **Emergency Numbers** — tap-to-dial contact numbers for national park
  offices.
- **Profile** — editable name and profile picture, persisted on-device.

Built in partnership branding with Ezemvelo KZN Wildlife and SANParks.

## Tech stack

- [Flutter](https://flutter.dev) / Dart
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) — map rendering
- [geolocator](https://pub.dev/packages/geolocator) — device location
- [url_launcher](https://pub.dev/packages/url_launcher) — dialing & external map directions
- [image_picker](https://pub.dev/packages/image_picker) — profile picture selection
- [shared_preferences](https://pub.dev/packages/shared_preferences) — local persistence

## Getting started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (this
   project targets a recent stable release).
2. Clone the repo and fetch dependencies:
   ```bash
   git clone https://github.com/samx95/safariworld.git
   cd safariworld
   flutter pub get
   ```
3. **Google Maps API key**: the Safari Map screen needs a Google Maps API
   key with the Maps SDK enabled. The keys in this repo are restricted to
   the original developer's app signing/bundle ID, so the map won't render
   on another machine's build out of the box. To test the Map screen,
   either:
   - Get in touch for a key added to the allowlist, or
   - Create your own key in the [Google Cloud Console](https://console.cloud.google.com)
     and swap it into `android/app/src/main/AndroidManifest.xml`,
     `ios/Runner/AppDelegate.swift`, and `web/index.html`.

   Every other screen works without any key.
4. Run it:
   ```bash
   flutter run                # picks a connected device/simulator
   flutter run -d chrome      # or specifically on web
   ```

## Project structure

```
lib/
  main.dart                    # app entry point, navigation, home screen
  models/user_profile.dart     # shared, persisted profile state
  screens/                     # one file per screen
test/widget_test.dart          # widget smoke test
```
