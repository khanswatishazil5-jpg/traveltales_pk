import 'package:flutter/material.dart';
import '../models/gallery_asset.dart';

/// A single image tile used in both grids on the Premium Vault
/// screen ("Premium Pixels" and "Saved Trails" tabs).
class AssetTile extends StatelessWidget {
  final GalleryAsset asset;
  const AssetTile({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset.image,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              color: scheme.primaryContainer,
              child: Icon(Icons.landscape_rounded, color: scheme.primary),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black45,
              child: Text(
                asset.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
