import '../models/post_model.dart';
import '../models/user_model.dart';
import 'mock_data.dart';
import 'post_repository.dart';

/// Frontend-only stage: every method just returns mock data (plus any
/// posts created locally via PostRepository, since there's no backend yet
/// to actually persist and share them).
/// Method names/signatures match what the backend will eventually serve,
/// so wiring in real http calls later is a small edit inside each method
/// (see /travel_tales_backend for the matching routes) — no changes needed
/// in any screen or widget when that happens.
class ApiService {
  final PostRepository _postRepository = PostRepository();

  Future<List<PostModel>> getFeed() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final localPosts = await _postRepository.getLocalPosts();
    return [...localPosts, ...MockData.posts];
  }

  Future<void> toggleLike(String postId, bool liked) async {
    // no-op for now — UI already updates optimistically
  }

  Future<void> toggleSave(String postId, bool saved) async {
    // no-op for now — UI already updates optimistically
  }

  Future<List<PlaceModel>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockData.places
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<UserModel>> searchPeople(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockData.people
        .where((p) => p.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<PostModel>> getRandomExplorePosts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final localPosts = await _postRepository.getLocalPosts();
    return [...localPosts, ...MockData.posts];
  }
}
