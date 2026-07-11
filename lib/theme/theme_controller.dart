import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the app's current seed color, persists it with
/// SharedPreferences, and notifies the UI whenever it changes.
///
/// This is a singleton (`ThemeController.instance`) so ANY widget,
/// anywhere in the tree, can read or update the color without
/// passing it down through constructors — call:
///   ThemeController.instance.updateSeedColor('Ocean Blue');
///
/// --------------------------------------------------------------
/// HOW TO ADD A NEW COLOR OPTION
/// Just add one line to the `colorOptions` map below. Nothing else
/// needs to change — the dropdown in ThemeColorPicker reads this
/// map automatically.
///   'Ruby Red': Color(0xFFB71C1C),
/// --------------------------------------------------------------
class ThemeController extends ChangeNotifier {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  static const String _prefsKey = 'seed_color_name';

  static const Map<String, Color> colorOptions = {
    'Forest Green': Color(0xFF1E4620),
    'Ocean Blue': Colors.blue,
    'Deep Purple': Colors.deepPurple,
    'Teal': Colors.teal,
    'Sunset Orange': Colors.deepOrange,
    'Blossom Pink': Colors.pink,
  };

  Color seedColor = Colors.blue; // default until SharedPreferences loads
  bool isLoading = true;

  /// Call once on app startup (done in app.dart). Reads the saved
  /// color name from disk and applies it, or keeps the default.
  Future<void> loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_prefsKey);

    if (savedName != null && colorOptions.containsKey(savedName)) {
      seedColor = colorOptions[savedName]!;
    }
    isLoading = false;
    notifyListeners(); // tells app.dart to rebuild MaterialApp's theme
  }

  /// Call when the user picks a new color from the dropdown.
  /// Saves it to disk AND updates the live theme immediately.
  Future<void> updateSeedColor(String colorName) async {
    if (!colorOptions.containsKey(colorName)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, colorName);

    seedColor = colorOptions[colorName]!;
    notifyListeners();
  }

  /// The name matching the current seedColor, used to show the
  /// correct value as "selected" in the dropdown.
  String get currentColorName {
    return colorOptions.entries
        .firstWhere(
          (entry) => entry.value == seedColor,
          orElse: () => colorOptions.entries.first,
        )
        .key;
  }
}
