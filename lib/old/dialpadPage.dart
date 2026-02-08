import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DialpadPage();
  }
}

class DialpadPage extends StatelessWidget {
  const DialpadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialpad'),
      ),
      body: Column(
        
      ),
    );
  }
}