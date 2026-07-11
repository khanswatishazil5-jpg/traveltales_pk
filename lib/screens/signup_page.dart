import 'package:flutter/material.dart';
import 'gallery_after_login.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        backgroundColor: scheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text(
              "Create Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "First Name", prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 14),
            const TextField(decoration: InputDecoration(labelText: "Last Name", prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 14),
            const TextField(decoration: InputDecoration(labelText: "Contact String", prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 14),
            const TextField(decoration: InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.mail))),
            const SizedBox(height: 14),
            const TextField(decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.fingerprint)), obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const GalleryAfterLogin()),
                (route) => false,
              ),
              child: const Text("Finalize Registration"),
            ),
          ],
        ),
      ),
    );
  }
}
