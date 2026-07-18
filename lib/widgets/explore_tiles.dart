import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'post_image.dart';
import '../services/follow_repository.dart';

/// One row in the Explore search results when searching Places.
class PlaceResultTile extends StatelessWidget {
  final PlaceModel place;
  const PlaceResultTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return _ResultRow(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.teal,
        backgroundImage: place.photoUrl != null ? NetworkImage(place.photoUrl!) : null,
        child: place.photoUrl == null
            ? const Icon(Icons.map_outlined, color: AppColors.paper)
            : null,
      ),
      title: place.name,
      subtitle: place.subtitle,
    );
  }
}

/// One row in the Explore search results when searching People.
class PersonResultTile extends StatefulWidget {
  final UserModel user;
  const PersonResultTile({super.key, required this.user});

  @override
  State<PersonResultTile> createState() => _PersonResultTileState();
}

class _PersonResultTileState extends State<PersonResultTile> {
  final _followRepository = FollowRepository();
  bool _following = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final following = await _followRepository.isFollowing(widget.user.username);
    if (!mounted) return;
    setState(() {
      _following = following;
      _loading = false;
    });
  }

  Future<void> _toggle() async {
    setState(() => _following = !_following);
    if (_following) {
      await _followRepository.follow(widget.user.username);
    } else {
      await _followRepository.unfollow(widget.user.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ResultRow(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.ink,
        child: Text(widget.user.avatarInitials, style: const TextStyle(color: AppColors.paper)),
      ),
      title: widget.user.username,
      subtitle: widget.user.bio,
      trailingLabel: _loading ? null : (_following ? 'Following' : 'Follow'),
      onTrailingTap: _loading ? null : _toggle,
    );
  }
}

class _ResultRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const _ResultRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.charcoal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (trailingLabel != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trailingLabel == 'Following' ? AppColors.coral : Colors.transparent,
                  border: Border.all(color: AppColors.coral),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trailingLabel!,
                  style: TextStyle(fontSize: 9.5, color: trailingLabel == 'Following' ? Colors.white : AppColors.coral),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Grid of random posts shown in Explore before the person searches for anything.
class RandomPostsGrid extends StatelessWidget {
  final List<PostModel> posts;
  const RandomPostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final p = posts[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PostImage(source: p.imageUrl, fit: BoxFit.cover),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xCC0F1423), Colors.transparent],
                    ),
                  ),
                  child: Text(p.location,
                      style: const TextStyle(color: Colors.white, fontSize: 10.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
