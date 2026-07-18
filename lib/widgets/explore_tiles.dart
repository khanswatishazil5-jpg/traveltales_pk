import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

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
class PersonResultTile extends StatelessWidget {
  final UserModel user;
  const PersonResultTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _ResultRow(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.ink,
        child: Text(user.avatarInitials, style: const TextStyle(color: AppColors.paper)),
      ),
      title: user.username,
      subtitle: user.bio,
      trailingLabel: user.following ? 'Following' : 'Follow',
    );
  }
}

class _ResultRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String? trailingLabel;

  const _ResultRow({required this.leading, required this.title, required this.subtitle, this.trailingLabel});

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.coral),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(trailingLabel!, style: const TextStyle(fontSize: 9.5, color: AppColors.coral)),
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
              Image.network(p.imageUrl, fit: BoxFit.cover),
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
