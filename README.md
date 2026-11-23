# Recipe App – Mini Data Listing & Detail App (Flutter)

Flutter app that fetches recipes from the free dummy API **https://dummyjson.com**.

## Features
- **Login screen** – dummyjson `/auth/login` API (demo: `emilys` / `emilyspass`), form validation, loading & error message
- **Listing screen** – `ListView` of cards (image, title, subtitle, rating, tags), pull-to-refresh
- **Search** – real-time filter by title, cuisine (category), tags, meal type
- **Detail screen** – image, rating, cuisine, difficulty, times, servings, calories, ingredients, step-by-step instructions
- **States** – loading indicator, error view with Retry (no internet / timeout / server error), empty state for no search results
- **State management** – Provider

## Folder Structure
```
lib/
├── main.dart
├── models/        recipe.dart, user.dart
├── services/      api_service.dart
├── providers/     auth_provider.dart, recipe_provider.dart
├── screens/       login_screen.dart, recipe_list_screen.dart, recipe_detail_screen.dart
└── widgets/       recipe_card.dart, app_search_bar.dart, state_views.dart, network_image_box.dart
```

## Run
```bash
flutter create .      # generates android/ios/web folders (one time)
flutter pub get
flutter run
```
Release build: add `<uses-permission android:name="android.permission.INTERNET"/>` in
`android/app/src/main/AndroidManifest.xml` (debug already has it).
