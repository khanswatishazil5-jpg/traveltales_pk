/// The signed-up device user's own profile.
/// Kept separate from UserModel (which represents *other* travelers shown
/// in Explore's People search) since this one carries an email and is
/// backed by local device storage, not the backend.
class ProfileModel {
  final String username;
  final String email;
  final String bio;
  final String avatarInitials;
  final String? avatarImageBase64;

  const ProfileModel({
    required this.username,
    required this.email,
    required this.bio,
    required this.avatarInitials,
    this.avatarImageBase64,
  });

  ProfileModel copyWith({String? bio, String? avatarImageBase64}) {
    return ProfileModel(
      username: username,
      email: email,
      bio: bio ?? this.bio,
      avatarInitials: avatarInitials,
      avatarImageBase64: avatarImageBase64 ?? this.avatarImageBase64,
    );
  }
}
