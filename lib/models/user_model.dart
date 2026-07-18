/// A traveler profile, as shown in Explore's People search results.
class UserModel {
  final String id;
  final String username;
  final String avatarInitials;
  final String bio;
  final bool following;

  UserModel({
    required this.id,
    required this.username,
    required this.avatarInitials,
    required this.bio,
    this.following = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'] as String,
      avatarInitials: json['avatarInitials'] as String? ??
          (json['username'] as String).substring(0, 2).toUpperCase(),
      bio: json['bio'] as String? ?? '',
      following: json['following'] as bool? ?? false,
    );
  }
}

/// A place result, as shown in Explore's Places search results
/// (backed by the Google Places API via our backend proxy).
class PlaceModel {
  final String placeId;
  final String name;
  final String subtitle;
  final String? photoUrl;
  final double? lat;
  final double? lng;

  PlaceModel({
    required this.placeId,
    required this.name,
    required this.subtitle,
    this.photoUrl,
    this.lat,
    this.lng,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}
