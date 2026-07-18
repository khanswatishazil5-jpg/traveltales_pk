import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

/// Stores posts created on this device so they show up in Feed/Explore/
/// Profile and survive app restarts. This is a stand-in for the real
/// database: once the backend exists, replace the body of these methods
/// with HTTP calls (same shape ApiService already documents) — no changes
/// needed in the screens that call this class.
///
/// NOTE: because there's no server yet, "other users" seeing these posts
/// really just means "this same device" — there's no sharing across
/// devices/accounts until the backend and real accounts exist.
class PostRepository {
  static const _kPostsKey = 'local_posts_v1';

  Future<List<PostModel>> getLocalPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kPostsKey) ?? [];
    return raw
        .map((s) => PostModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
        .reversed // newest first
        .toList();
  }

  Future<void> addPost(PostModel post) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kPostsKey) ?? [];
    raw.add(jsonEncode(post.toJson()));
    await prefs.setStringList(_kPostsKey, raw);
  }

  Future<void> deletePost(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kPostsKey) ?? [];
    raw.removeWhere((s) {
      final json = jsonDecode(s) as Map<String, dynamic>;
      return json['id'] == postId;
    });
    await prefs.setStringList(_kPostsKey, raw);
  }

  Future<void> updatePost(PostModel updated) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kPostsKey) ?? [];
    final newRaw = raw.map((s) {
      final json = jsonDecode(s) as Map<String, dynamic>;
      if (json['id'] == updated.id) {
        return jsonEncode(updated.toJson());
      }
      return s;
    }).toList();
    await prefs.setStringList(_kPostsKey, newRaw);
  }
}
