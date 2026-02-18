import './http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  await NotificationService().requestPermission();
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
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffF6EEFF), Color(0xffFDEBFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        size: 80,
                        color: AppTheme.lavender,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'ThoughtDrop',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lavender,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const CircularProgressIndicator(
                        color: AppTheme.lavender,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Initializing...',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return snapshot.data == true ? const DashboardPage() : const LoginPage();
        },
      ),
    );
  }
}
