import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ApiService _api = ApiService();
  List<PostModel> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final posts = await _api.getFeed();
    setState(() {
      _posts = posts;
      _loading = false;
    });
  }

  void _toggleLike(PostModel post) {
    setState(() {
      post.liked = !post.liked;
      post.likes += post.liked ? 1 : -1;
    });
    _api.toggleLike(post.id, post.liked);
  }

  void _toggleSave(PostModel post) {
    setState(() => post.saved = !post.saved);
    _api.toggleSave(post.id, post.saved);
  }

  void _share(PostModel post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link copied for "${post.location}"')),
    );
  }

  void _comment(PostModel post) {
    // Hook up to a comments screen/bottom sheet next.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comments screen — next build.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _posts.length,
        itemBuilder: (context, i) {
          final post = _posts[i];
          return PostCard(
            post: post,
            onLike: () => _toggleLike(post),
            onSave: () => _toggleSave(post),
            onShare: () => _share(post),
            onComment: () => _comment(post),
          );
        },
      ),
    );
  }
}
