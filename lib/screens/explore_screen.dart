import 'dart:async';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/explore_tiles.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _api = ApiService();
  SearchMode _mode = SearchMode.places;
  String _query = '';
  Timer? _debounce;

  List<PostModel> _randomPosts = [];
  List<PlaceModel> _placeResults = [];
  List<UserModel> _peopleResults = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRandom();
  }

  Future<void> _loadRandom() async {
    final posts = await _api.getRandomExplorePosts();
    setState(() {
      _randomPosts = posts;
      _loading = false;
    });
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _runSearch(q));
  }

  Future<void> _runSearch(String q) async {
    setState(() => _query = q);
    if (q.trim().isEmpty) return;
    if (_mode == SearchMode.places) {
      final results = await _api.searchPlaces(q);
      setState(() => _placeResults = results);
    } else {
      final results = await _api.searchPeople(q);
      setState(() => _peopleResults = results);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final hasQuery = _query.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TravelSearchBar(
            mode: _mode,
            onModeChanged: (m) => setState(() {
              _mode = m;
              if (hasQuery) _runSearch(_query);
            }),
            onChanged: _onQueryChanged,
          ),
          if (!hasQuery) ...[
            const Text('DISCOVER — RANDOM TALES',
                style: TextStyle(fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            RandomPostsGrid(posts: _randomPosts),
          ] else if (_mode == SearchMode.places) ...[
            if (_placeResults.isEmpty)
              const _EmptyState(text: 'No places match yet.')
            else
              ..._placeResults.map((p) => PlaceResultTile(place: p)),
          ] else ...[
            if (_peopleResults.isEmpty)
              const _EmptyState(text: 'No travelers match yet.')
            else
              ..._peopleResults.map((u) => PersonResultTile(user: u)),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.black45))),
    );
  }
}
