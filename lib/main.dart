import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDCgZdZMiQmQ3Q9kVAd7BX3nK0dpu46twM",
        authDomain: "traveltales-pk-maps.firebaseapp.com",
        projectId: "traveltales-pk-maps",
        storageBucket: "traveltales-pk-maps.firebasestorage.app",
        messagingSenderId: "277582163991",
        appId: "1:277582163991:web:35a5450ebb20864bcdec52",
      ),
    );
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Firebase initialization error: $e");
  }

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