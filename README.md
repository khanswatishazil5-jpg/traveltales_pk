# Travel Tales — Flutter Frontend

## Structure (separated by responsibility)

```
lib/
  models/          PostModel, UserModel, PlaceModel
  services/        ApiService (talks to the Dart backend), mock_data.dart (offline fallback)
  theme/           app_theme.dart — colors, type, shared component styling
  widgets/         PostCard, QuestionBox, TravelSearchBar, explore result tiles
  screens/         FeedScreen, ExploreScreen, HomeShell (bottom nav)
  main.dart        entry point
```

## Run locally

```bash
flutter pub get
cp .env.example .env     # fill in API_BASE_URL once the backend is deployed
flutter run
```

Works with no backend running — `ApiService` catches request failures and
falls back to `mock_data.dart`, so every screen still renders.

## Wiring to the backend

Once `/travel_tales_backend` is deployed (see its README), set:

```
API_BASE_URL=https://travel-tales-api-xxxx.run.app
```

in `.env`. No code changes needed — `ApiService` picks it up automatically.

## Google Maps / Places

`google_maps_flutter` is included for a future "view on map" screen. The
actual Places **search** (used in Explore) is proxied through the backend
(`GET /explore/places`) so the Google API key never ships inside the app —
put the real key only in the backend's env vars, not here.

## Deploy draft

- **Android**: `flutter build appbundle` → upload to Play Console.
- **iOS**: `flutter build ipa` → upload via Transporter/Xcode to App Store Connect (needs a Mac + Apple Developer account).
- **Web preview** (fastest way to demo without app store review):
  `flutter build web` → deploy the `build/web` folder to Firebase Hosting or Netlify.

## Not built yet (next passes)

- Comments screen (button is wired up, shows a placeholder toast)
- Profile screen (tab exists, placeholder content)
- Auth (login/signup screens + token storage)
- Image upload flow for creating a new post
