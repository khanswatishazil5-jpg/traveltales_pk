import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- ADD A NEW PLACE ---
  Future<void> addPlace({
    required String name,
    required String description,
    required double lat,
    required double lng,
  }) async {
    await _firestore.collection('places').add({
      'name': name,
      'description': description,
      'location': GeoPoint(lat, lng),
      'createdAt': DateTime.now(),
    });
  }

  // --- GET ALL PLACES (REAL-TIME) ---
  Stream<List<Map<String, dynamic>>> getPlaces() {
    return _firestore.collection('places').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed',
          'description': data['description'] ?? '',
          'lat': data['location']?.latitude ?? 0.0,
          'lng': data['location']?.longitude ?? 0.0,
        };
      }).toList();
    });
  }
}