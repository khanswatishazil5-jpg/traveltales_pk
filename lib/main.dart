import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // CLO3: persistence package

void main() {
  // WidgetsFlutterBinding must be ready before we touch SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NatureGalleryApp());
}

//added comments

/* ============================================================
   CLO3 CHANGE #1
   NatureGalleryApp is now STATEFUL so it can:2

     1. Read the saved seed color from SharedPreferences on launch
     2. Rebuild the whole MaterialApp (and therefore the global
        theme) the instant the user picks a new color
   Any widget in the tree can reach this state with
   `NatureGalleryApp.of(context)` and call `updateSeedColor(name)`.
   ============================================================ */
class NatureGalleryApp extends StatefulWidget {
  const NatureGalleryApp({super.key});

  @override
  State<NatureGalleryApp> createState() => _NatureGalleryAppState();

  /// Lets any descendant widget grab the state and change the theme.
  static _NatureGalleryAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NatureGalleryAppState>();
}

class _NatureGalleryAppState extends State<NatureGalleryApp> {
  // Key used to store/retrieve the color inside SharedPreferences
  static const String _prefsKey = 'seed_color_name';

  // Default seed color used the very first time the app is opened
  // (i.e. when nothing has been saved yet)
  Color _seedColor = Colors.blue;

  // Simple flag so we don't flash the default theme before the
  // saved value has finished loading from disk
  bool _isLoading = true;

  // The dropdown options: a friendly name mapped to a real Color.
  // We store the *name* (a String) in SharedPreferences because
  // SharedPreferences cannot store a Color object directly.
  static const Map<String, Color> colorOptions = {
    'Forest Green': Color(0xFF1E4620),
    'Ocean Blue': Colors.blue,
    'Deep Purple': Colors.deepPurple,
    'Teal': Colors.teal,
    'Sunset Orange': Colors.deepOrange,
    'Blossom Pink': Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedColor();
  }

  /// STEP 1 of the assignment: on startup, check SharedPreferences
  /// for a saved color. If found, use it. If not, keep the default.
  Future<void> _loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_prefsKey);

    setState(() {
      if (savedName != null && colorOptions.containsKey(savedName)) {
        _seedColor = colorOptions[savedName]!;
      }
      _isLoading = false;
    });
  }

  /// STEP 2 of the assignment: called when the user picks a new
  /// color from the dropdown. Saves it to SharedPreferences AND
  /// updates state so the whole app rebuilds with the new theme.
  Future<void> updateSeedColor(String colorName) async {
    if (!colorOptions.containsKey(colorName)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, colorName); // persist immediately

    setState(() {
      _seedColor = colorOptions[colorName]!; // rebuild global theme now
    });
  }

  /// Helper so UI code (the dropdown) can show which color is
  /// currently selected without keeping a second copy of state.
  String get currentColorName {
    return colorOptions.entries
        .firstWhere(
          (entry) => entry.value == _seedColor,
          orElse: () => colorOptions.entries.first,
        )
        .key;
  }

  @override
  Widget build(BuildContext context) {
    // While we're still reading SharedPreferences, show a tiny
    // loading screen instead of a flash of the wrong theme.
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earthy Nature Gallery',
      theme: ThemeData(
        useMaterial3: true,
        // CLO3: the ENTIRE color scheme is now derived from the
        // seed color the user picked (or the saved/default one).
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        fontFamily: 'Poppins',
        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: _seedColor.withOpacity(0.2),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _seedColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

/* -------------------- MAIN SCREEN (BOTTOM NAV) -------------------- */
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget> screens = [
    const HomePage(),
    const GalleryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() {
            index = i;
          });
        },
        indicatorColor: scheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.blur_on_rounded),
            selectedIcon: Icon(Icons.eco),
            label: "Explore",
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: "Collection",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

/* -------------------- HOME PAGE -------------------- */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> places = [
    {'image': 'assets/forest.jpg', 'title': 'Mystic Forest', 'desc': 'Deep wooden trails'},
    {'image': 'assets/mountain.jpg', 'title': 'Alps Peak', 'desc': 'Snowcapped horizons'},
    {'image': 'assets/lake.jpg', 'title': 'Emerald Lake', 'desc': 'Calm pristine waters'},
    {'image': 'assets/ocean.jpg', 'title': 'Pacific Wave', 'desc': 'Endless turquoise tides'},
    {'image': 'assets/waterfall.jpg', 'title': 'Cascade Falls', 'desc': 'Hidden canyon flows'},
    {'image': 'assets/pond.jpg', 'title': 'Zen Pond', 'desc': 'Peaceful lotus sanctuaries'},
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌿 Earthy Gallery", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: scheme.primary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover Wonders",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                      image: const DecorationImage(
                        image: AssetImage('assets/waterfall.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 24,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adventure Awaits",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Explore untouched ecosystems today",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Curated Collections",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                itemCount: places.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Image.asset(
                              places[i]['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.landscape, size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                places[i]['title']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                places[i]['desc']!,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- GALLERY PAGE -------------------- */
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collection Room", style: TextStyle(color: Colors.white)),
        backgroundColor: scheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 80, color: scheme.secondary.withOpacity(0.6)),
              const SizedBox(height: 16),
              const Text(
                "Unlock Vault",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Log in or register your account to start curating your natural cloud album.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.vpn_key),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                label: const Text("Authenticate Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- PROFILE PAGE -------------------- */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

/* -------------------- LOGIN PAGE -------------------- */
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appState = NatureGalleryApp.of(context);
    final currentColorName = appState?.currentColorName ?? 'Forest Green';

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

            /* ============================================================
               CLO3 CHANGE #2 — THE REQUIRED DROPDOWN
               Lets the user pick a favorite color. On change we:
                 1. Save the choice to SharedPreferences (via updateSeedColor)
                 2. Trigger setState() in NatureGalleryApp, which rebuilds
                    ThemeData with the new seed color -> global theme change
               ============================================================ */
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Theme Color",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pick your favorite color — it's saved automatically and reapplied every time you reopen the app.",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: currentColorName,
                      decoration: const InputDecoration(
                        labelText: "Favorite Color",
                        prefixIcon: Icon(Icons.palette_outlined),
                      ),
                      items: _NatureGalleryAppState.colorOptions.keys.map((name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _NatureGalleryAppState.colorOptions[name],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        NatureGalleryApp.of(context)?.updateSeedColor(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Theme set to $value and saved!"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const TextField(
              decoration: InputDecoration(
                labelText: "Email/Username",
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: "Secure Password",
                prefixIcon: Icon(Icons.lock_open_rounded),
              ),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const GalleryAfterLogin()),
                  );
                },
                child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupPage()),
                );
              },
              child: Text("New Explorer? Setup Account", style: TextStyle(color: scheme.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- SIGNUP PAGE -------------------- */
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
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryAfterLogin()),
                  (route) => false,
                );
              },
              child: const Text("Finalize Registration"),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- AFTER LOGIN GALLERY (ADVANCED COMPONENTS) -------------------- */
// Assignment 2: Utilizing Nested Tabs, Dynamic Extension Anchors, and Advanced Component Architectures
class GalleryAfterLogin extends StatelessWidget {
  const GalleryAfterLogin({super.key});

  static const List<Map<String, String>> premiumImages = [
    {'img': 'assets/forest.jpg', 'name': 'Amazon Rain'},
    {'img': 'assets/mountain.jpg', 'name': 'Fuji Peaks'},
    {'img': 'assets/lake.jpg', 'name': 'Lake Como'},
    {'img': 'assets/ocean.jpg', 'name': 'Maldives Bay'},
  ];

  static const List<Map<String, String>> trailMaps = [
    {'img': 'assets/mountain.jpg', 'name': 'Ridge Pathway'},
    {'img': 'assets/forest.jpg', 'name': 'Deep Woods Route'},
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Premium Vault", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: scheme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (route) => false,
                );
              },
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.photo_outlined), text: "Premium Pixels"),
              Tab(icon: Icon(Icons.map_outlined), text: "Saved Trails"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab One Content Layout
            buildGridTabContent(context, premiumImages),
            // Tab Two Content Layout
            buildGridTabContent(context, trailMaps),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          onPressed: () {},
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text("Import Asset"),
        ),
      ),
    );
  }

  Widget buildGridTabContent(BuildContext context, List<Map<String, String>> sourceList) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Synchronized Assets (${sourceList.length})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: scheme.primary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: sourceList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (ctx, idx) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      sourceList[idx]['img']!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: scheme.primaryContainer,
                        child: Icon(Icons.landscape_rounded, color: scheme.primary),
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black45,
                        child: Text(
                          sourceList[idx]['name']!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
