import 'package:flutter/material.dart';
import 'home_page.dart';
import 'gallery_page.dart';
import 'profile_page.dart';

/// Hosts the 3-tab bottom navigation bar (Explore / Collection / Account).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget> screens = const [
    HomePage(),
    GalleryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        indicatorColor: scheme.primaryContainer,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.blur_on_rounded), selectedIcon: Icon(Icons.eco), label: "Explore"),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library), label: "Collection"),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
