/// A single travel post in the feed.
class PostModel {
  final String id;
  final String username;
  final String avatarInitials;
  final String location;
  final String imageUrl;
  String caption;
  int likes;
  bool liked;
  bool saved;
  final Map<String, String> qa; // question label -> answer text

  PostModel({
    required this.id,
    required this.username,
    required this.avatarInitials,
    required this.location,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.qa,
    this.liked = false,
    this.saved = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'].toString(),
      username: json['username'] as String,
      avatarInitials: json['avatarInitials'] as String? ??
          (json['username'] as String).substring(0, 2).toUpperCase(),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      likes: json['likes'] as int? ?? 0,
      liked: json['liked'] as bool? ?? false,
      saved: json['saved'] as bool? ?? false,
      qa: Map<String, String>.from(json['qa'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'avatarInitials': avatarInitials,
        'location': location,
        'imageUrl': imageUrl,
        'caption': caption,
        'likes': likes,
        'liked': liked,
        'saved': saved,
        'qa': qa,
      };
}
