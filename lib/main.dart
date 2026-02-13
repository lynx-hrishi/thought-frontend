import './http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './theme.dart';
import './login_page.dart';
import './pages/dashboard_page.dart';
import './services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await HttpService().init();
  await NotificationService().initialize();
  runApp(const ThoughtDropApp());
}

class ThoughtDropApp extends StatefulWidget {
  const ThoughtDropApp({super.key});

  @override
  State<ThoughtDropApp> createState() => _ThoughtDropAppState();
}

class _ThoughtDropAppState extends State<ThoughtDropApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ThoughtDrop',
      theme: AppTheme.theme,
      home: FutureBuilder<bool>(
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
      ),
    );
  }
}
