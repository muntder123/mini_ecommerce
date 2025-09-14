# Mini E-commerce App

A Flutter mini e-commerce application that loads products from the Fake Store API with infinite scroll, search, filters, and a persistent cart using Hive/SQLite.

## Features

- **Product Loading**: Fetches products from https://fakestoreapi.com/products
- **Infinite Scroll**: Loads more products as you scroll
- **Search & Filters**: Search products by title/description and filter by category
- **Persistent Cart**: Cart data survives app restarts using Hive
- **Offline-First**: Cached products available when offline
- **Mock Checkout**: Simulated checkout flow with success/failure handling
- **Clean UI**: Material Design 3 with RTL support
- **State Management**: Riverpod for reactive state management

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android/iOS emulator or physical device

### Installation Steps

1. **Clone the repository** (if applicable) or ensure you have the project files

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate localization files**:
   ```bash
   flutter gen-l10n
   ```

4. **Generate Hive adapters** (if needed):
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Ensure you have Android SDK installed
- Create an Android Virtual Device (AVD) or connect a physical device
- Run: `flutter run` (will detect Android device automatically)

#### iOS
- macOS with Xcode installed
- Run: `flutter run` (will detect iOS simulator/device)

#### Web
- Run: `flutter run -d chrome`
- Note: Web platform uses IndexedDB for storage instead of local files

### Dependencies Used

- **flutter_riverpod**: State management
- **hive & hive_flutter**: Local storage for cart and caching
- **http**: API calls
- **cached_network_image**: Image caching
- **connectivity_plus**: Network status detection
- **intl**: Internationalization support

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── product.dart          # Product and Rating models
│   └── cart_item.dart        # Cart item model
├── providers/
│   ├── cart_provider.dart    # Cart state management
│   ├── products_provider.dart # Products state management
│   ├── categories_provider.dart # Categories provider
│   └── connectivity_provider.dart # Network connectivity
├── screens/
│   ├── home_screen.dart      # Main screen with navigation
│   ├── products_screen.dart  # Products list with search/filters
│   └── cart_screen.dart      # Cart and checkout
├── services/
│   ├── api_service.dart      # API service for products
│   └── hive_service.dart     # Hive database service
└── widgets/                  # Reusable widgets (if any)
```

### API Endpoints

- `GET /products` - Fetch all products (with pagination)
- `GET /products/categories` - Fetch product categories
- `GET /products/category/{category}` - Fetch products by category

### Offline Functionality

- Products are cached locally using Hive
- Cart persists across app restarts
- App works offline with cached data
- Syncs with server when back online

### Platform Compatibility

- **Android/iOS**: Full functionality with local file storage
- **Web**: Uses IndexedDB for storage, full functionality
- **Desktop**: Full functionality with local file storage

### RTL Support

The app is configured for RTL (Right-to-Left) support for Arabic and other RTL languages. Currently set to English locale, but can be easily switched to Arabic by updating the locale in `main.dart`:

```dart
locale: const Locale('ar', ''), // For Arabic RTL support
```

To enable full Arabic localization, add `flutter_localizations` package and proper delegates.

## Troubleshooting

### Common Issues

1. **App hangs on Flutter logo (Android)**:
   - **Cause**: Missing internet permission in Android manifest
   - **Solution**: The app requires internet access for API calls. Make sure the Android manifest includes:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
     ```
   - **Alternative**: Clean and rebuild: `flutter clean && flutter pub get && flutter run`

2. **Build errors**: Run `flutter clean` then `flutter pub get`

3. **Hive errors**: Delete the app from device/emulator and reinstall

4. **Network issues**: Check internet connection and API availability

5. **Web platform issues**: Clear browser cache and IndexedDB storage

6. **Localization errors**: Run `flutter gen-l10n` to regenerate translation files
5. **Localization errors**: App is set to English locale by default. For Arabic RTL, update locale in `main.dart`

### Debug Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check device connection
flutter devices

# Analyze code
flutter analyze
```

## License

This project is for educational purposes.
