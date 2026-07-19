import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';
import 'home_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(
          "📡 Auth state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}",
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          print("✅ Logged in as: ${snapshot.data!.email}");

          return HomeShell(
            onLoggedOut: () async {
              await FirebaseAuth.instance.signOut();
            },
          );
        }

        print("❌ User not logged in");

        return const LoginPage();
      },
    );
  }
}