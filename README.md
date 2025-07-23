# 🎬 Sinflix

A production-ready movie discovery Flutter application built with Clean Architecture, MVVM pattern, and BLoC state management.

## 🌟 Features

### Core Features
- **Authentication System** - Login & Registration with JWT tokens
- **Movie Discovery** - Browse movies with infinite scroll pagination (5 movies per page)
- **Favorites Management** - Add/remove movies from favorites with real-time UI updates
- **Profile Management** - User profile with photo upload functionality
- **Pull-to-Refresh** - Refresh movie lists with smooth animations
- **Offline Support** - Cache movies for offline viewing with Hive database

### UI/UX Features
- **Netflix-inspired Dark Theme** - Beautiful dark theme with red accent colors
- **Shimmer Loading Effects** - Elegant loading animations
- **Lottie Animations** - Smooth vector animations
- **Limited Offer Bottom Sheet** - Special token packages UI
- **Custom Components** - Reusable widgets and components

### Technical Features
- **Clean Architecture** - Domain, Data, and Presentation layers
- **MVVM Pattern** - Model-View-ViewModel architecture
- **BLoC State Management** - Reactive state management with flutter_bloc
- **Internationalization** - Multi-language support (Turkish & English) with ARB files
- **Secure Storage** - Token management with flutter_secure_storage
- **Network Layer** - Retrofit with Dio for API calls and interceptors
- **Error Handling** - Comprehensive error handling and user feedback
- **Dependency Injection** - GetIt for dependency management

## 🏗️ Architecture

```
lib/
├── core/                          # Core utilities and services
│   ├── constants/                 # App constants and configurations
│   ├── error/                     # Error handling (Failures & Exceptions)
│   ├── extensions/                # Extension methods
│   ├── injection/                 # Dependency injection setup
│   ├── network/                   # Network layer (Dio, Interceptors, API Client)
│   ├── services/                  # Core services (Auth, Logger, Navigation, Storage)
│   └── theme/                     # App theme and styling
├── data/                          # Data layer
│   ├── datasources/               # Remote and local data sources
│   ├── models/                    # Data models with JSON serialization
│   └── repositories/              # Repository implementations
├── domain/                        # Domain layer
│   ├── entities/                  # Business entities
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Business use cases
├── presentation/                  # Presentation layer
│   ├── blocs/                     # BLoC state management
│   ├── pages/                     # App screens and pages
│   ├── routes/                    # Navigation routing
│   └── widgets/                   # Reusable UI components
├── l10n/                          # Internationalization
│   ├── app_en.arb                 # English translations
│   └── app_tr.arb                 # Turkish translations
└── main.dart                      # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Firebase project (for analytics and crashlytics)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/shartflix.git
   cd shartflix
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Firebase Setup**
   - Create a new Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

[Add screenshots of your app here]

## 🔧 Configuration

### API Configuration
Update the base URL in `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://caseapi.servicelabs.tech/';
```

### Language Configuration
The app supports Turkish and English. Default language is Turkish. You can change this in:
```dart
static const String defaultLanguage = 'tr';
```

## 📚 API Documentation

The app uses the following API endpoints:

- **POST** `/user/login` - User login
- **POST** `/user/register` - User registration  
- **GET** `/user/profile` - Get user profile
- **POST** `/user/upload_photo` - Upload profile photo
- **GET** `/movie/list?page={page}` - Get movies (paginated)
- **GET** `/movie/favorites` - Get user's favorite movies
- **POST** `/movie/favorite/{movieId}` - Toggle movie favorite status

## 🏃‍♂️ Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🔨 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc` - State management
- `go_router` - Navigation
- `dio` & `retrofit` - Network layer
- `hive` & `hive_flutter` - Local database
- `get_it` & `injectable` - Dependency injection
- `dartz` - Functional programming

### UI Dependencies
- `cached_network_image` - Image caching
- `shimmer` - Loading animations
- `lottie` - Vector animations
- `image_picker` - Photo selection

### Utility Dependencies
- `intl` - Internationalization
- `logger` - Logging
- `firebase_core`, `firebase_crashlytics`, `firebase_analytics` - Firebase services

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Netflix for UI/UX inspiration
- Flutter team for the amazing framework
- All the package maintainers whose libraries made this possible

## 📞 Support

If you have any questions or need help, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**