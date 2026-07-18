import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../models/profile_model.dart';
import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/post_repository.dart';
import '../services/follow_repository.dart';
import '../widgets/post_image.dart';
import 'create_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLoggedOut;

  const ProfileScreen({super.key, required this.onLoggedOut});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _postRepository = PostRepository();
  final _followRepository = FollowRepository();
  final _picker = ImagePicker();

  ProfileModel? _profile;
  List<PostModel> _myPosts = [];
  int _followingCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    ProfileModel? profile;
    List<PostModel> myPosts = [];
    int followingCount = 0;
    try {
      profile = await _authService.getProfile();
      if (profile != null) {
        final allLocalPosts = await _postRepository.getLocalPosts();
        myPosts = allLocalPosts.where((p) => p.username == profile!.username).toList();
      }
      followingCount = await _followRepository.getFollowingCount();
    } catch (_) {
      profile = null;
    }
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _myPosts = myPosts;
      _followingCount = followingCount;
      _loading = false;
    });
  }

  Future<void> _pickAvatar() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final base64Str = base64Encode(bytes);
      final dataUri = 'data:image/jpeg;base64,$base64Str';
      await _authService.updateAvatarImage(dataUri);
      if (!mounted) return;
      setState(() => _profile = _profile?.copyWith(avatarImageBase64: dataUri));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't open your photos: $e")),
      );
    }
  }

  Future<void> _openCreatePost() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
    if (created == true) {
      _load();
    }
  }

  Future<void> _editBio() async {
    final profile = _profile;
    if (profile == null) return;
    final controller = TextEditingController(text: profile.bio);

    final newBio = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Edit bio'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          maxLength: 120,
          decoration: const InputDecoration(hintText: 'Tell people about your travels'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newBio == null) return;
    await _authService.updateBio(newBio);
    if (!mounted) return;
    setState(() => _profile = profile.copyWith(bio: newBio));
  }

  Future<void> _confirmLogOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Log out?'),
        content: const Text('You can log back in with the same username and password.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.logOut();
      widget.onLoggedOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = _profile;
    if (profile == null) {
      return const Center(child: Text('Profile not found.'));
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              _Avatar(
                initials: profile.avatarInitials,
                imageBase64: profile.avatarImageBase64,
                onTap: _pickAvatar,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(label: 'Posts', value: '${_myPosts.length}'),
                    const _StatColumn(label: 'Followers', value: '0'),
                    _StatColumn(label: 'Following', value: '$_followingCount'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.username,
            style: TextStyle(fontFamily: AppFonts.display, fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
          const SizedBox(height: 4),
          Text(profile.email, style: const TextStyle(color: AppColors.charcoal, fontSize: 13)),
          const SizedBox(height: 8),
          Text(profile.bio, style: const TextStyle(color: AppColors.ink)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _editBio,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.ink, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Edit profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _confirmLogOut,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral,
                    side: const BorderSide(color: AppColors.coral, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Log out'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openCreatePost,
              icon: const Icon(Icons.add_a_photo_outlined),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.teal,
                side: const BorderSide(color: AppColors.teal, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              label: const Text('Add a travel tale'),
            ),
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.line),
          const SizedBox(height: 20),
          _myPosts.isEmpty ? const _EmptyPostsState() : _PostsGrid(posts: _myPosts, onChanged: _load),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final String? imageBase64;
  final VoidCallback onTap;

  const _Avatar({required this.initials, required this.imageBase64, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2, style: BorderStyle.solid),
            ),
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            child: imageBase64 == null
                ? Text(
                    initials,
                    style: TextStyle(fontFamily: AppFonts.display, fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink),
                  )
                : PostImage(source: imageBase64!, fit: BoxFit.cover),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.coral, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontFamily: AppFonts.mono, fontSize: 10, letterSpacing: 0.8, color: AppColors.charcoal),
        ),
      ],
    );
  }
}

class _PostsGrid extends StatelessWidget {
  final List<PostModel> posts;
  final VoidCallback onChanged;
  const _PostsGrid({required this.posts, required this.onChanged});

  Future<void> _showOptions(BuildContext context, PostModel post) async {
    final repository = PostRepository();
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.ink),
              title: const Text('Edit caption'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.coral),
              title: const Text('Delete', style: TextStyle(color: AppColors.coral)),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (action == 'delete') {
      if (!context.mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Delete this tale?'),
          content: const Text('This can\'t be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await repository.deletePost(post.id);
        onChanged();
      }
    } else if (action == 'edit') {
      if (!context.mounted) return;
      final controller = TextEditingController(text: post.caption);
      final newCaption = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Edit caption'),
          content: TextField(controller: controller, maxLines: 3),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (newCaption != null) {
        post.caption = newCaption;
        await repository.updatePost(post);
        onChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, i) {
        return GestureDetector(
          onLongPress: () => _showOptions(context, posts[i]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: PostImage(source: posts[i].imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

class _EmptyPostsState extends StatelessWidget {
  const _EmptyPostsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold, width: 1.5, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.photo_camera_back_outlined, size: 32, color: AppColors.teal),
          SizedBox(height: 12),
          Text(
            'No travel tales yet',
            style: TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
          SizedBox(height: 6),
          Text(
            'Tap "Add a travel tale" to share your first one.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.charcoal, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
