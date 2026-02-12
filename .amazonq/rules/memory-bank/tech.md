# Technology Stack

## Programming Languages

### Dart (Primary)
- **Version**: SDK ^3.9.2
- **Usage**: Main application logic, UI, and business logic
- **Location**: `/lib` directory

### Kotlin
- **Usage**: Android native code
- **Location**: `/android/app/src/main/kotlin`

### Swift
- **Usage**: iOS and macOS native code
- **Location**: `/ios/Runner`, `/macos/Runner`

### C++
- **Usage**: Windows and Linux native runners
- **Location**: `/windows/runner`, `/linux/runner`

### Python
- **Usage**: iOS build helper scripts
- **Location**: `/ios/Flutter/ephemeral`

## Framework & Runtime

### Flutter
- **Version**: Latest stable (SDK constraint ^3.9.2)
- **Platform Support**: Android, iOS, Web, Windows, Linux, macOS
- **Material Design**: Material 3 (useMaterial3: true)

## Core Dependencies

### HTTP & Networking
- **dio** (^5.4.0) - Advanced HTTP client with interceptors
- **dio_cookie_manager** (^3.1.0) - Cookie management for Dio
- **cookie_jar** (^4.0.8) - Cookie persistence
- **http** - Standard HTTP package (version not pinned)

### UI & Styling
- **google_fonts** (^6.1.0) - Custom font integration
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Media & Files
- **image_picker** (^1.0.7) - Image selection from gallery/camera
- **path_provider** (^2.1.2) - File system path access

## Development Dependencies

### Testing & Quality
- **flutter_test** - Flutter testing framework (SDK)
- **flutter_lints** (^5.0.0) - Recommended linting rules

## Build Systems

### Android
- **Gradle**: Version 8.12
- **Build Configuration**: Kotlin DSL (build.gradle.kts)
- **Min SDK**: Configured in android/app/build.gradle.kts

### iOS
- **Xcode Project**: Runner.xcodeproj
- **CocoaPods**: Dependency management
- **Build Configs**: Debug.xcconfig, Release.xcconfig

### Web
- **Build Output**: Standard Flutter web build
- **PWA Support**: manifest.json configured

### Windows
- **CMake**: Build system
- **MSVC**: C++ compiler

### Linux
- **CMake**: Build system
- **GTK**: UI framework
- **GCC/Clang**: C++ compiler

### macOS
- **Xcode**: Build system
- **Swift**: Native code compilation

## Development Commands

### Setup
```bash
flutter pub get              # Install dependencies
flutter pub upgrade          # Update dependencies
```

### Running
```bash
flutter run                  # Run on connected device
flutter run -d chrome        # Run on web
flutter run -d windows       # Run on Windows
flutter run -d macos         # Run on macOS
flutter run -d linux         # Run on Linux
```

### Building
```bash
flutter build apk            # Android APK
flutter build appbundle      # Android App Bundle
flutter build ios            # iOS build
flutter build web            # Web build
flutter build windows        # Windows executable
flutter build macos          # macOS app
flutter build linux          # Linux executable
```

### Testing & Analysis
```bash
flutter test                 # Run tests
flutter analyze              # Static analysis
flutter doctor               # Check environment
```

### Cleaning
```bash
flutter clean                # Clean build artifacts
flutter pub cache repair     # Repair package cache
```

## API Configuration

### Backend Base URL
- **Production**: https://meters-deferred-casey-hang.trycloudflare.com
- **Timeout**: 15 seconds (connect & receive)
- **Content-Type**: application/json

## Storage & Persistence

### Cookie Storage
- **Location**: Application documents directory + `.cookies/`
- **Implementation**: PersistCookieJar with FileStorage
- **Expiry**: Respects cookie expiration

### Local Storage
- **Chat Messages**: ChatStorageService (implementation in services/)
- **User Session**: Cookie-based persistence

## Platform-Specific Features

### Android
- Material Design components
- Gradle-based dependency management
- Kotlin coroutines support

### iOS
- Cupertino design components
- Swift async/await support
- CocoaPods integration

### Web
- Progressive Web App capabilities
- Responsive design
- Browser-based storage

### Desktop (Windows/Linux/macOS)
- Native window management
- File system access
- Platform-specific UI adaptations
