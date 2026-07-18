import 'package:flutter/material.dart';
import 'theme/theme_controller.dart';
import 'screens/main_screen.dart';


/// Root widget of the app. Its only jobs are:
///  1. Kick off loading the saved color when the app starts.
///  2. Listen to [ThemeController] and rebuild the MaterialApp's
///     ThemeData whenever the seed color changes.
class NatureGalleryApp extends StatefulWidget {
  const NatureGalleryApp({super.key});

  @override
  State<NatureGalleryApp> createState() => _NatureGalleryAppState();
}

class _NatureGalleryAppState extends State<NatureGalleryApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.loadSavedColor();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder rebuilds every time ThemeController calls
    // notifyListeners() — no extra package needed, it's built into Flutter.
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final controller = ThemeController.instance;

        if (controller.isLoading) {
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
            colorScheme: ColorScheme.fromSeed(seedColor: controller.seedColor),
            fontFamily: 'Poppins',
            cardTheme: CardThemeData(
              elevation: 6,
              shadowColor: controller.seedColor.withOpacity(0.2),
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
                borderSide: BorderSide(color: controller.seedColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
