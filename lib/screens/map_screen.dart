import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/firestore_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // --- MAP CONTROLLER ---
  final FirestoreService _firestoreService = FirestoreService();
  late GoogleMapController _mapController;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.3753, 69.3451),
    zoom: 5.0,
  );
  static final LatLngBounds _pakistanBounds = LatLngBounds(
    southwest: const LatLng(23.0, 61.0),
    northeast: const LatLng(37.0, 81.0),
  );

  // --- SEARCH STATE ---
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;

  // --- LIST OF PAKISTANI CITIES (with coordinates) ---
  final Map<String, LatLng> _pakistanCities = {
    'Islamabad': LatLng(33.6844, 73.0479),
    'Karachi': LatLng(24.8607, 67.0011),
    'Lahore': LatLng(31.5204, 74.3587),
    'Rawalpindi': LatLng(33.5651, 73.0169),
    'Faisalabad': LatLng(31.4504, 73.1350),
    'Multan': LatLng(30.1575, 71.5249),
    'Peshawar': LatLng(34.0151, 71.5249),
    'Quetta': LatLng(30.1798, 66.9750),
    'Sialkot': LatLng(32.4945, 74.5229),
    'Gujranwala': LatLng(32.1617, 74.1883),
    'Hyderabad': LatLng(25.3960, 68.3578),
    'Abbottabad': LatLng(34.1688, 73.2215),
    'Murree': LatLng(33.9062, 73.3903),
    'Hunza Valley': LatLng(36.3167, 74.6500),
    'Skardu': LatLng(35.2971, 75.6333),
    'Gilgit': LatLng(35.9187, 74.3079),
    'Swat': LatLng(35.2221, 72.4250),
    'Chitral': LatLng(35.8519, 71.7864),
    'Bahawalpur': LatLng(29.3956, 71.6836),
    'Sukkur': LatLng(27.7052, 68.8574),
  };

  // --- MARKERS ---
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadInitialMarkers();
  }

  void _loadInitialMarkers() {
    _pakistanCities.forEach((city, position) {
      _markers.add(
        Marker(
          markerId: MarkerId(city),
          position: position,
          infoWindow: InfoWindow(title: city),
        ),
      );
    });
    setState(() {});
  }

  // --- SEARCH FUNCTION ---
  void _searchCities(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
        return;
      }
      _searchResults = _pakistanCities.keys
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // --- SELECT CITY ---
  void _selectCity(String cityName) {
    final position = _pakistanCities[cityName]!;
    setState(() {
      _searchController.clear();
      _searchResults = [];
      _isSearching = false;
    });

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 12),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📍 ${cityName} found!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  // --- ON MAP CREATED ---
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🇵🇰 Explore Pakistan'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // --- MAP ---
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            minMaxZoomPreference: const MinMaxZoomPreference(4.5, 15.0),
            cameraTargetBounds: CameraTargetBounds(_pakistanBounds),
            myLocationEnabled: false,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: false,
            markers: _markers,
          ),

          // --- SEARCH UI ---
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchCities,
                    decoration: InputDecoration(
                      hintText: '🔍 Search cities in Pakistan...',
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchResults = [];
                            _isSearching = false;
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                // Search Results
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final city = _searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.location_city, color: Colors.green),
                          title: Text(city),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _selectCity(city),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      // ✅ MOVED BUTTON TO LEFT SIDE
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _firestoreService.addPlace(
              name: 'Test Place',
              description: 'This is a test from Flutter!',
              lat: 30.3753,
              lng: 69.3451,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Place added to Firestore!'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}