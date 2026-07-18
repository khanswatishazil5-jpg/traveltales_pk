import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import 'question_box.dart';
import 'post_image.dart';

/// Renders a single travel post: header (avatar, username, location),
/// photo, action row (like/comment/save/share), caption, and the
/// collapsible QuestionBox underneath.
class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    required this.onComment,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(color: Color(0x121F2A44), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(post: post),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: PostImage(source: post.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          _ActionRow(
            post: post,
            onLike: widget.onLike,
            onSave: widget.onSave,
            onShare: widget.onShare,
            onComment: widget.onComment,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.charcoal, fontSize: 13.5, height: 1.5),
                children: [
                  TextSpan(
                    text: '${post.username}  ',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: QuestionBox(qa: post.qa),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final PostModel post;
  const _Header({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.teal,
            child: Text(
              post.avatarInitials,
              style: const TextStyle(color: AppColors.paper, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.username,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5, color: AppColors.ink)),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 13, color: AppColors.teal),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(post.location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.teal)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onComment;

  const _ActionRow({
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      child: Row(
        children: [
          _ActionButton(
            icon: post.liked ? Icons.favorite : Icons.favorite_border,
            color: post.liked ? AppColors.coral : AppColors.charcoal,
            label: '${post.likes}',
            onTap: onLike,
          ),
          _ActionButton(
            icon: Icons.mode_comment_outlined,
            color: AppColors.charcoal,
            label: 'comment',
            onTap: onComment,
          ),
          _ActionButton(
            icon: post.saved ? Icons.bookmark : Icons.bookmark_border,
            color: post.saved ? AppColors.teal : AppColors.charcoal,
            label: 'save',
            onTap: onSave,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.ios_share, size: 20, color: AppColors.charcoal),
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, color: color)),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6)),
    );
  }
}
