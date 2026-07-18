import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'feed_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  final VoidCallback onLoggedOut;

  const HomeShell({super.key, required this.onLoggedOut});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  late final _screens = [
    const FeedScreen(),
    const ExploreScreen(),
    ProfileScreen(onLoggedOut: widget.onLoggedOut),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.flight, color: AppColors.coral),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Travel Tales', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                Text('PAR AVION · EST. 2026',
                    style: TextStyle(fontSize: 9, letterSpacing: 1.2, color: AppColors.coral)),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.card,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
