import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/pakistan_locations.dart';

/// Returns the chosen location as a String, or null if cancelled.
Future<String?> showLocationPicker(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
  );
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final _searchController = TextEditingController();
  List<PakistanLocation> _results = PakistanLocations.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _results = PakistanLocations.search(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        title: const Text('Choose a location'),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search northern areas, cities...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('No matches — try the field below.', style: TextStyle(color: AppColors.charcoal)))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final loc = _results[i];
                        return ListTile(
                          leading: const Icon(Icons.place_outlined, color: AppColors.teal),
                          title: Text(loc.name, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                          subtitle: Text(loc.region, style: const TextStyle(color: AppColors.charcoal)),
                          onTap: () => Navigator.of(context).pop(loc.displayName),
                        );
                      },
                    ),
            ),
            const Divider(color: AppColors.line, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Can't find it? Type your own below.",
                      style: TextStyle(color: AppColors.charcoal, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final text = _searchController.text.trim();
                      if (text.isNotEmpty) Navigator.of(context).pop(text);
                    },
                    child: const Text('Use this text', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
