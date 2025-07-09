# 🚀 Flutter Clean Architecture with Riverpod

A comprehensive Flutter project template built with Clean Architecture principles, Riverpod state management, and advanced features for production-ready applications.

## ✨ Features

### 🏗️ **Architecture & State Management**
- **Clean Architecture** with clear separation of concerns
- **Riverpod** for state management and dependency injection
- **Freezed** for immutable data classes
- **Result Pattern** for error handling
- **Repository Pattern** for data access

### 🌐 **API & Networking**
- **Dio** for HTTP requests with interceptors
- **Retrofit** for type-safe API clients
- **Caching** with local storage
- **Network connectivity** checking
- **Request/Response logging** in debug mode

### 🎨 **UI & UX**
- **Adaptive UI** supporting Material (Android/Web) and Cupertino (iOS)
- **Theme management** with light/dark mode support
- **Responsive design** for all screen sizes
- **Loading states** and error handling
- **Pull-to-refresh** functionality

### 📊 **Analytics & Tracking**
- **Firebase Analytics** integration (ready for implementation)
- **Custom event tracking**
- **Screen view tracking**
- **Error tracking**
- **Purchase tracking**

### 🔔 **Push Notifications**
- **Firebase Cloud Messaging** support
- **Local notifications**
- **Topic subscription**
- **Background message handling**
- **Notification tap handling**

### 🔗 **Deep Linking**
- **GoRouter** integration
- **Dynamic link handling**
- **Route-based navigation**
- **Parameter passing**
- **Universal link support**

### 🌍 **Internationalization (i18n)**
- **Multi-language support** (English & Arabic)
- **RTL layout** support
- **Date/time formatting**
- **Number formatting**
- **Pluralization support**

### 💾 **State Persistence**
- **Local storage** for app state
- **JSON serialization**
- **State restoration**
- **Automatic saving** of theme, language, and posts
- **Settings management** with data clearing
- **SettingsController** for centralized settings management
- **Encryption support** (ready for implementation)

### 🧪 **Testing**
- **Unit tests** with Mockito
- **Widget tests**
- **Integration tests** ready
- **Test coverage** reporting

## 📁 Project Structure

```
lib/
├── core/
│   ├── analytics/           # Analytics tracking
│   ├── api/                # API clients and services
│   ├── deep_linking/       # Deep link handling
│   ├── exceptions/         # Custom exceptions
│   ├── http_client.dart    # HTTP client configuration
│   ├── interceptors/       # Dio interceptors
│   ├── i18n/              # Internationalization
│   ├── logger.dart         # Logging utility
│   ├── network/            # Network connectivity
│   ├── persistence/        # State persistence
│   ├── providers.dart      # Global providers
│   ├── result.dart         # Result pattern
│   ├── storage/            # Local storage
│   ├── theme/              # Theme management
│   └── widgets/            # Reusable widgets
├── features/
│   └── posts/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── controllers/
│           └── pages/
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd flutter_riverpod_tmplt
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## 🔧 Configuration

### Environment Setup

1. **Create environment files**
```bash
# .env.development
API_BASE_URL=https://jsonplaceholder.typicode.com
ENABLE_ANALYTICS=false
ENABLE_NOTIFICATIONS=false

# .env.production
API_BASE_URL=https://your-api.com
ENABLE_ANALYTICS=true
ENABLE_NOTIFICATIONS=true
```

2. **Configure Firebase** (optional)
```bash
# Add google-services.json (Android)
# Add GoogleService-Info.plist (iOS)
# Configure firebase_options.dart
```

### Platform Configuration

#### Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

#### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.example.app</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myapp</string>
        </array>
    </dict>
</array>
```

## 📱 Usage Examples

### Analytics Tracking
```dart
final analytics = ref.read(analyticsServiceProvider);
await analytics.logEvent('button_clicked', parameters: {'button': 'create_post'});
await analytics.logScreenView('posts_page');
```

### Push Notifications
```dart
final notifications = ref.read(notificationServiceProvider);
await notifications.requestPermission();
await notifications.subscribeToTopic('general');
await notifications.showLocalNotification(
  title: 'New Post',
  body: 'Someone created a new post!',
);
```

### Deep Linking
```dart
final deepLink = ref.read(deepLinkServiceProvider);
deepLink.navigateToPost(123);
deepLink.navigateToUser(456);
deepLink.navigateToSettings();
```

### State Persistence
```dart
// Automatic saving (already implemented)
final persistence = ref.read(statePersistenceServiceProvider);
await persistence.saveState('user_preferences', userPrefs);
final prefs = await persistence.loadState('user_preferences', UserPrefs.fromJson);

// Clear all data
await persistence.clearAllStates();
```

### Internationalization
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.posts);
Text(l10n.formatDate(DateTime.now()));
Text(l10n.getRelativeTime(post.createdAt));
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod: ^2.6.1` - State management
- `dio: ^5.8.0+1` - HTTP client
- `freezed_annotation: ^3.1.0` - Immutable classes
- `json_annotation: ^4.9.0` - JSON serialization
- `shared_preferences: ^2.5.3` - Local storage
- `connectivity_plus: ^6.1.4` - Network connectivity
- `retrofit: ^4.6.0` - Type-safe API client

### UI Dependencies
- `flutter_local_notifications: ^18.0.1` - Local notifications
- `go_router: ^14.6.2` - Navigation and deep linking
- `intl: ^0.19.0` - Internationalization

### Development Dependencies
- `build_runner: ^2.5.4` - Code generation
- `freezed: ^3.1.0` - Code generation for Freezed
- `json_serializable: ^6.9.5` - JSON code generation
- `retrofit_generator: ^9.7.0` - Retrofit code generation
- `mockito: ^5.4.6` - Testing mocks
- `flutter_lints: ^5.0.0` - Code linting

## 🔄 Code Generation

Run code generation whenever you modify:
- Freezed classes
- JSON serializable classes
- Retrofit API clients

```bash
# Watch for changes
dart run build_runner watch

# Build once
dart run build_runner build --delete-conflicting-outputs
```

## 🚀 Deployment

### Build for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### App Store Deployment
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
# Then archive in Xcode
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run tests and linting
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the example code

## 🔮 Roadmap

- [ ] Firebase Analytics integration
- [ ] Firebase Cloud Messaging setup
- [ ] Advanced caching strategies
- [ ] Offline support
- [ ] Biometric authentication
- [ ] In-app purchases
- [ ] Social media integration
- [ ] Advanced animations
- [ ] Performance monitoring
- [ ] Crash reporting

---

**Built with ❤️ using Flutter and Clean Architecture principles**
