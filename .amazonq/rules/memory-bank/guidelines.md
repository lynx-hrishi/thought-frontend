# Development Guidelines

## Code Quality Standards

### Naming Conventions
- **Classes**: PascalCase (e.g., `DashboardPage`, `UserModel`, `HttpService`)
- **Files**: snake_case matching class names (e.g., `dashboard_page.dart`, `user_model.dart`, `http_service.dart`)
- **Variables**: camelCase (e.g., `isOtpComplete`, `secondsRemaining`, `emailController`)
- **Private members**: Prefix with underscore (e.g., `_selectedIndex`, `_initialized`, `_normalizeGender`)
- **Constants**: camelCase for theme colors (e.g., `lavender`, `pink`, `bg`)

### File Organization
- One primary class per file
- File name matches the main class name in snake_case
- Related helper functions can be in the same file (e.g., `isValidEmail`, `continueBtnHandler` in login_page.dart)
- Platform-specific code in dedicated directories with appropriate extensions (.kt, .swift, .cpp, .h)

### Import Organization
- Relative imports for local files (e.g., `import './http_service.dart'`)
- Package imports for dependencies (e.g., `import 'package:flutter/material.dart'`)
- Group imports logically: Flutter SDK → Third-party packages → Local files

### Code Formatting
- Use `const` constructors wherever possible for performance
- Trailing commas on multi-line parameter lists for better formatting
- 2-space indentation (Dart standard)
- Line length: Keep reasonable, break long lines logically
- Empty lines between logical sections

## Structural Conventions

### Widget Architecture
- Separate StatefulWidget and State classes (e.g., `DashboardPage` + `_DashboardPageState`)
- Use `const` constructors for StatelessWidget when possible
- Always include `super.key` parameter in constructors
- Override `dispose()` to clean up resources (controllers, timers, animations)

### State Management Pattern
```dart
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // State variables here
  
  @override
  void initState() {
    super.initState();
    // Initialization
  }

  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(/* ... */);
  }
}
```

### Singleton Pattern for Services
```dart
class HttpService {
  static final HttpService _instance = HttpService._internal();
  
  factory HttpService() => _instance;
  
  HttpService._internal();
  
  // Service methods
}
```

### Model Classes
- Immutable data classes with final fields
- Required parameters in constructor
- Optional parameters with nullable types (e.g., `String?`, `int?`)
- No fromJson/toJson methods (manual parsing in service layer)

```dart
class UserModel {
  final String id;
  final String email;
  final String? optionalField;
  
  UserModel({
    required this.id,
    required this.email,
    this.optionalField,
  });
}
```

## Semantic Patterns

### Async/Await Pattern
- Always use `async`/`await` for asynchronous operations
- Use `Future<T>` return types explicitly
- Handle errors with try-catch blocks
- Show user feedback via SnackBar for errors

```dart
Future<void> verifyOtp() async {
  try {
    Response res = await httpService.otpVerify(email: email, otp: otp);
    // Handle success
  } catch(err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err.toString())),
    );
  }
}
```

### Navigation Pattern
- Use `Navigator.push` for forward navigation
- Use `Navigator.pushReplacement` for authentication flows
- Use `MaterialPageRoute` for page transitions

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardPage(),
  ),
);
```

### FutureBuilder Pattern
- Use for async data loading in build method
- Always handle `ConnectionState.waiting`
- Provide loading indicators during async operations

```dart
FutureBuilder<bool>(
  key: UniqueKey(),
  future: HttpService().checkSession(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return snapshot.data == true ? const DashboardPage() : const LoginPage();
  },
)
```

### Animation Pattern
- Use `SingleTickerProviderStateMixin` for single animations
- Create AnimationController in initState
- Dispose controllers in dispose method
- Use `AnimatedBuilder` for animation-driven UI updates

```dart
class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    shakeAnimation = Tween<double>(begin: 0, end: 12)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(shakeController);
  }

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }
}
```

### Timer Pattern
- Store timer reference for cleanup
- Cancel timers in dispose
- Use `Timer.periodic` for recurring tasks

```dart
Timer? timer;

void startTimer() {
  timer = Timer.periodic(const Duration(seconds: 1), (t) {
    if (condition) {
      t.cancel();
    } else {
      setState(() => counter--);
    }
  });
}

@override
void dispose() {
  timer?.cancel();
  super.dispose();
}
```

## Internal API Usage Patterns

### HttpService Usage
```dart
// Initialize once at app startup
await HttpService().init();

// Use singleton instance throughout app
HttpService httpService = HttpService();

// API calls with named parameters
Response res = await httpService.loginUser(email: email);
Response res = await httpService.otpVerify(email: email, otp: otp);
List<UserModel> users = await httpService.getMatchesForUsers(page: 1, limit: 10);
```

### Dio Configuration
```dart
dio = Dio(
  BaseOptions(
    baseUrl: "https://api.example.com",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'}
  )
);

// Add interceptors for cross-cutting concerns
dio.interceptors.add(CookieManager(cookieJar));
dio.interceptors.add(LogInterceptor(requestUrl: true));
```

### Custom ImageProvider Pattern
```dart
class DioImage extends ImageProvider<DioImage> {
  final String url;
  final double scale;
  final int? cacheKey;

  const DioImage(this.url, {this.scale = 1.0, this.cacheKey});

  @override
  Future<DioImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(DioImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  // Implement equality for caching
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DioImage && 
           other.url == url && 
           other.scale == scale &&
           other.cacheKey == cacheKey;
  }

  @override
  int get hashCode => Object.hash(url, scale, cacheKey);
}
```

### Theme Usage
```dart
// Define theme in separate file
class AppTheme {
  static const lavender = Color(0xFF7E57C2);
  static const pink = Color(0xFFEC407A);
  
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(seedColor: lavender),
    // ... other theme properties
  );
}

// Apply in MaterialApp
MaterialApp(
  theme: AppTheme.theme,
  // ...
)

// Reference colors directly
color: AppTheme.pink
```

### Form Input Controllers
```dart
// Create controllers
final emailController = TextEditingController();
final List<TextEditingController> controllers = 
    List.generate(6, (_) => TextEditingController());

// Use in TextField
TextField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(hintText: "Enter email"),
)

// Extract values
String email = emailController.text.trim();
String otp = controllers.map((c) => c.text).join();

// Always dispose
@override
void dispose() {
  emailController.dispose();
  for (var c in controllers) {
    c.dispose();
  }
  super.dispose();
}
```

## Frequently Used Code Idioms

### Conditional Widget Rendering
```dart
// Ternary operator for simple conditions
secondsRemaining == 0
    ? TextButton(onPressed: () {}, child: const Text("Resend"))
    : Text("Resend in $secondsRemaining s")

// Conditional list items
if (isWide) Expanded(child: InfoPanel()),

// Null-aware operators
user?.name ?? 'Unknown'
response.data?.isEmpty ?? true
```

### List Generation
```dart
// Generate list of widgets
List.generate(6, (index) => otpBox(index))

// Map list to widgets
_pages[_selectedIndex]

// Transform API data
List<String> userImages = [profileImage];
for (var img in postImages) {
  userImages.add(img.toString());
}

// Type-safe list conversion
List<String>.from(user['interests'])
```

### Responsive Design Pattern
```dart
final isWide = MediaQuery.of(context).size.width >= 700;

Row(
  children: [
    if (isWide) Expanded(child: LeftPanel()),
    Expanded(child: MainContent()),
  ],
)
```

### Gradient Containers
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEDE7F6), Color(0xFFFCE4EC)],
    ),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: /* ... */,
)
```

## Popular Annotations & Modifiers

### Widget Annotations
- `const` - Compile-time constant widgets for performance
- `super.key` - Pass key to parent widget constructor
- `required` - Mark mandatory named parameters
- `late` - Late initialization for non-nullable fields
- `final` - Immutable fields

### State Lifecycle
- `@override` - Override parent class methods
- `initState()` - Initialize state before first build
- `dispose()` - Clean up resources when widget removed
- `didChangeDependencies()` - React to inherited widget changes

### Async Annotations
- `async` - Mark function as asynchronous
- `await` - Wait for Future to complete
- `Future<T>` - Return type for async operations

## Best Practices

### Performance
- Use `const` constructors wherever possible
- Dispose controllers, timers, and listeners
- Avoid rebuilding entire widget trees unnecessarily
- Use `ListView.builder` for long lists (not shown in samples but recommended)

### Error Handling
- Always wrap API calls in try-catch
- Provide user feedback via SnackBar
- Log errors for debugging (print statements in development)
- Handle null values with null-aware operators

### Security
- Never commit API keys or credentials
- Use environment variables for sensitive data
- Validate user input (email validation example in login_page.dart)
- Use HTTPS for all network requests

### Code Organization
- Keep widgets small and focused
- Extract reusable components to separate files
- Use helper functions for complex logic
- Separate business logic from UI code (service layer pattern)

### Platform-Specific Code
- Minimal platform code - extend Flutter framework classes only
- Kotlin: Extend `FlutterActivity` for Android
- Swift: Use `FlutterViewController` for iOS/macOS
- C++: Use GTK for Linux, Win32 for Windows
- Keep platform code simple - delegate to Flutter when possible
