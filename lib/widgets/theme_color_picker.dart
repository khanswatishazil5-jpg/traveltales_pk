import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

/// A self-contained card with the "favorite color" dropdown.
/// Drop `const ThemeColorPicker()` into any screen and it will
/// read/update the app-wide [ThemeController] on its own — no
/// parameters needed.
class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = ThemeController.instance;

    return Card(
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
              value: controller.currentColorName,
              decoration: const InputDecoration(
                labelText: "Favorite Color",
                prefixIcon: Icon(Icons.palette_outlined),
              ),
              items: ThemeController.colorOptions.keys.map((name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: ThemeController.colorOptions[name],
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
                controller.updateSeedColor(value);
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
    );
  }
}
