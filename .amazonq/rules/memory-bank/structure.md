# Project Structure

## Directory Organization

### `/lib` - Main Application Code
Core Flutter application source code organized by feature and responsibility.

#### `/lib/pages/` - UI Pages
- `chat_page.dart` - Individual chat conversation interface
- `dashboard_page.dart` - Main user dashboard after login
- `edit_profile_page.dart` - Profile editing interface
- `match_page.dart` - Match browsing and swiping interface
- `messages_page.dart` - Message list overview
- `profile_page.dart` - User profile display
- `user_card.dart` - Reusable user card component

#### `/lib/widgets/` - Reusable Components
- `dio_image.dart` - Custom image provider using Dio for network images

#### `/lib/components/` - UI Components
- `textfieldComponent.dart` - Reusable text field component

#### `/lib/models/` - Data Models
- `user_model.dart` - User data structure
- `dummy_data_provider.dart` - Mock data for development

#### `/lib/services/` - Business Logic
- `chat_storage_service.dart` - Local chat message persistence

#### `/lib/old/` - Legacy Code
Archived implementations and experimental code (not in active use).

#### Root `/lib/` Files
- `main.dart` - Application entry point and routing
- `http_service.dart` - Centralized HTTP client with Dio
- `login_page.dart` - Authentication entry page
- `otp_page.dart` - OTP verification page
- `personal_details_page.dart` - User onboarding details
- `match_preferences_page.dart` - Partner preference configuration
- `theme.dart` - Application-wide theme configuration
- `page_transition.dart` - Custom page transition animations

### `/android` - Android Platform Code
Native Android configuration and build files.
- Kotlin-based MainActivity
- Gradle build configuration (Kotlin DSL)
- Android manifest and resources

### `/ios` - iOS Platform Code
Native iOS configuration and build files.
- Swift-based AppDelegate
- Xcode project configuration
- iOS-specific assets and entitlements

### `/web` - Web Platform Code
Progressive Web App configuration.
- HTML entry point
- Web manifest
- Favicon and icons

### `/windows` - Windows Platform Code
Native Windows desktop application support.
- C++ runner implementation
- CMake build configuration
- Windows-specific resources

### `/linux` - Linux Platform Code
Native Linux desktop application support.
- C++ runner implementation
- GTK-based application wrapper
- CMake build configuration

### `/macos` - macOS Platform Code
Native macOS desktop application support.
- Swift-based window management
- Xcode project configuration
- macOS-specific entitlements

### `/test` - Test Files
Unit and widget tests for the application.

## Core Components & Relationships

### Authentication Flow
```
LoginPage → OtpPage → PersonalDetailsPage → MatchPreferencesPage → DashboardPage
```

### HTTP Service Architecture
- Singleton pattern for HttpService
- Dio client with cookie management
- Persistent session storage
- Centralized API endpoint configuration

### State Management
- StatefulWidget-based state management
- FutureBuilder for async operations
- Session-based authentication state

### Image Loading Pipeline
```
DioImage (ImageProvider) → HttpService → Dio → Network → UI.Codec → Flutter Widget
```

## Architectural Patterns

### Singleton Pattern
- `HttpService` uses singleton pattern for centralized HTTP client management

### Provider Pattern
- Custom `DioImage` extends `ImageProvider` for network image loading

### Service Layer Pattern
- Separation of HTTP logic in `HttpService`
- Chat storage abstraction in `ChatStorageService`

### Model-View Pattern
- Data models in `/models`
- UI pages in `/pages`
- Reusable widgets in `/widgets` and `/components`

### Multi-Platform Architecture
- Platform-specific code in dedicated directories
- Shared Dart codebase in `/lib`
- Platform channels for native functionality
