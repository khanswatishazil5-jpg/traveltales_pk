import 'package:flutter/material.dart';
import '../models/place.dart';
import '../widgets/place_grid_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Place> places = [
    Place(image: 'assets/forest.jpg', title: 'Mystic Forest', desc: 'Deep wooden trails'),
    Place(image: 'assets/mountain.jpg', title: 'Alps Peak', desc: 'Snowcapped horizons'),
    Place(image: 'assets/lake.jpg', title: 'Emerald Lake', desc: 'Calm pristine waters'),
    Place(image: 'assets/ocean.jpg', title: 'Pacific Wave', desc: 'Endless turquoise tides'),
    Place(image: 'assets/waterfall.jpg', title: 'Cascade Falls', desc: 'Hidden canyon flows'),
    Place(image: 'assets/pond.jpg', title: 'Zen Pond', desc: 'Peaceful lotus sanctuaries'),
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
              Text("Discover Wonders", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: scheme.primary)),
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                      image: const DecorationImage(image: AssetImage('assets/waterfall.jpg'), fit: BoxFit.cover),
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
                        Text("Adventure Awaits", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("Explore untouched ecosystems today", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text("Curated Collections", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scheme.primary)),
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
                itemBuilder: (context, i) => PlaceGridCard(place: places[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
