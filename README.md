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

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- A code editor (e.g., VS Code, Android Studio)
- API access for movie data (configure via `.env`)

### Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/UlasKasim/shartflix.git
   cd shartflix
   ```

2. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**:

   - Create a `.env` file in the project root.
   - Copy the contents of `.env.example` and update the `BASE_URL` with the appropriate API endpoint.

     ```bash
     cp .env.example .env
     ```
   - Example `.env` content:

     ```env
     BASE_URL=https://api.example.com
     ```

4. **Generate Code**: Run the following command to generate necessary files (e.g., for dependency injection, JSON serialization):

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the App**:

   ```bash
   flutter run
   ```

### Running Tests

To execute the test suite:

```bash
flutter test
```

**Note**: Current test coverage is approximately 10% due to time constraints. Contributions to improve test coverage are welcome!

## 📚 Additional Notes

- Ensure the API endpoint in `.env` is accessible to avoid network errors.
- For code generation issues, re-run the `build_runner` command with `--delete-conflicting-outputs`.
