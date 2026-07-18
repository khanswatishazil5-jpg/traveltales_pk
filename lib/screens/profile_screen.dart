import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLoggedOut;

  const ProfileScreen({super.key, required this.onLoggedOut});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  ProfileModel? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    ProfileModel? profile;
    try {
      profile = await _authService.getProfile();
    } catch (_) {
      profile = null;
    }
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loading = false;
    });
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
              _Avatar(initials: profile.avatarInitials),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _StatColumn(label: 'Posts', value: '0'),
                    _StatColumn(label: 'Followers', value: '0'),
                    _StatColumn(label: 'Following', value: '0'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.username,
            style: const TextStyle(fontFamily: 'Fraunces', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink),
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
          const SizedBox(height: 28),
          const Divider(color: AppColors.line),
          const SizedBox(height: 20),
          _EmptyPostsState(),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2, style: BorderStyle.solid),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(fontFamily: 'Fraunces', fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink),
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
          style: const TextStyle(fontFamily: 'Space Mono', fontSize: 10, letterSpacing: 0.8, color: AppColors.charcoal),
        ),
      ],
    );
  }
}

class _EmptyPostsState extends StatelessWidget {
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
          const Icon(Icons.photo_camera_back_outlined, size: 32, color: AppColors.teal),
          const SizedBox(height: 12),
          const Text(
            'No travel tales yet',
            style: TextStyle(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
          const SizedBox(height: 6),
          const Text(
            'Posting your own trips is coming soon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.charcoal, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
