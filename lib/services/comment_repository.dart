import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/comment_model.dart';

/// Stores comments per post on this device. Same pattern as PostRepository:
/// once the backend/database exists, swap the body of these methods for
/// real HTTP calls — the screens calling this class won't need to change.
class CommentRepository {
  static const _kCommentsKey = 'local_comments_v1';

  Future<List<CommentModel>> getCommentsFor(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kCommentsKey) ?? [];
    return raw
        .map((s) => CommentModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .where((c) => c.postId == postId)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> addComment(CommentModel comment) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kCommentsKey) ?? [];
    raw.add(jsonEncode(comment.toJson()));
    await prefs.setStringList(_kCommentsKey, raw);
  }
}
