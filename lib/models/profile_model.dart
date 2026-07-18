/// The signed-up device user's own profile.
/// Kept separate from UserModel (which represents *other* travelers shown
/// in Explore's People search) since this one carries an email and is
/// backed by local device storage, not the backend.
class ProfileModel {
  final String username;
  final String email;
  final String bio;
  final String avatarInitials;

  const ProfileModel({
    required this.username,
    required this.email,
    required this.bio,
    required this.avatarInitials,
  });

  ProfileModel copyWith({String? bio}) {
    return ProfileModel(
      username: username,
      email: email,
      bio: bio ?? this.bio,
      avatarInitials: avatarInitials,
    );
  }
}
