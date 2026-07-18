import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which usernames this device's user follows. Same local-storage
/// stand-in pattern as PostRepository/CommentRepository — swap for real
/// backend calls once accounts are server-side and shared across devices.
class FollowRepository {
  static const _kFollowingKey = 'local_following_v1';

  Future<Set<String>> getFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_kFollowingKey) ?? []).toSet();
  }

  Future<bool> isFollowing(String username) async {
    final following = await getFollowing();
    return following.contains(username);
  }

  Future<void> follow(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final following = await getFollowing();
    following.add(username);
    await prefs.setStringList(_kFollowingKey, following.toList());
  }

  Future<void> unfollow(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final following = await getFollowing();
    following.remove(username);
    await prefs.setStringList(_kFollowingKey, following.toList());
  }

  Future<int> getFollowingCount() async {
    final following = await getFollowing();
    return following.length;
  }
}
