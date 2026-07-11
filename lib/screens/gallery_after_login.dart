import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../models/gallery_asset.dart';
import '../widgets/asset_tile.dart';

/// Assignment 2: Utilizing Nested Tabs, Dynamic Extension Anchors,
/// and Advanced Component Architectures
class GalleryAfterLogin extends StatelessWidget {
  const GalleryAfterLogin({super.key});

  static const List<GalleryAsset> premiumImages = [
    GalleryAsset(image: 'assets/forest.jpg', name: 'Amazon Rain'),
    GalleryAsset(image: 'assets/mountain.jpg', name: 'Fuji Peaks'),
    GalleryAsset(image: 'assets/lake.jpg', name: 'Lake Como'),
    GalleryAsset(image: 'assets/ocean.jpg', name: 'Maldives Bay'),
  ];

  static const List<GalleryAsset> trailMaps = [
    GalleryAsset(image: 'assets/mountain.jpg', name: 'Ridge Pathway'),
    GalleryAsset(image: 'assets/forest.jpg', name: 'Deep Woods Route'),
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              ),
            ),
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
            _buildGridTabContent(context, premiumImages),
            _buildGridTabContent(context, trailMaps),
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

  Widget _buildGridTabContent(BuildContext context, List<GalleryAsset> sourceList) {
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
              itemBuilder: (ctx, idx) => AssetTile(asset: sourceList[idx]),
            ),
          ),
        ],
      ),
    );
  }
}
