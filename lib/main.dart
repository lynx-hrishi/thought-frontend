import './http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './theme.dart';
import './login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await HttpService().init();
  runApp(const ThoughtDropApp());
}

class ThoughtDropApp extends StatelessWidget {
  const ThoughtDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ThoughtDrop',
      theme: AppTheme.theme,
      home: const LoginPage(),
    );
  }
}
