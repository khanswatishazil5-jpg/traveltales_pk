import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'gallery_after_login.dart';
import '../widgets/theme_color_picker.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Access Portal", style: TextStyle(color: Colors.white)),
        backgroundColor: scheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.flutter_dash_rounded, size: 70, color: scheme.primary),
            const SizedBox(height: 12),
            const Text("Welcome Back Explorer", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // CLO3 requirement: dropdown to pick + persist the theme color
            const ThemeColorPicker(),

            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(labelText: "Email/Username", prefixIcon: Icon(Icons.alternate_email)),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Secure Password", prefixIcon: Icon(Icons.lock_open_rounded)),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GalleryAfterLogin())),
                child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
              child: Text("New Explorer? Setup Account", style: TextStyle(color: scheme.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}
