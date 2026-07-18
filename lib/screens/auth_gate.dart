import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Check current user directly
    final user = FirebaseAuth.instance.currentUser;

    print("🔍 Current user: ${user?.email ?? 'null'}");

    if (user != null) {
      print("✅ User logged in: ${user.email}");
      return const MainScreen();
    }

    print("❌ No user, showing LoginPage");
    return const LoginPage();
  }
}