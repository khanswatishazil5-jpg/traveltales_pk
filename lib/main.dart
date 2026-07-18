import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth_gate.dart';

void main() {
  runApp(const TravelTalesApp());
}

class TravelTalesApp extends StatelessWidget {
  const TravelTalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Tales',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthGate(),
    );
  }
}
