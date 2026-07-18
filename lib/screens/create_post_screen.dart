import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/post_repository.dart';
import '../widgets/post_image.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  final _authService = AuthService();
  final _postRepository = PostRepository();
  final _picker = ImagePicker();

  String? _imageDataUri;
  bool _saving = false;
  String? _errorText;

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final base64Str = base64Encode(bytes);
      setState(() => _imageDataUri = 'data:image/jpeg;base64,$base64Str');
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorText = "Couldn't open your photos: $e");
    }
  }

  Future<void> _submit() async {
    if (_imageDataUri == null) {
      setState(() => _errorText = 'Add a photo first.');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      setState(() => _errorText = 'Add a location for your tale.');
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      final profile = await _authService.getProfile();
      final username = profile?.username ?? 'you';
      final avatarInitials = profile?.avatarInitials ?? 'YOU';

      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        avatarInitials: avatarInitials,
        location: _locationController.text.trim(),
        imageUrl: _imageDataUri!,
        caption: _captionController.text.trim(),
        likes: 0,
        qa: const {},
      );

      await _postRepository.addPost(post);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorText = 'Something went wrong saving your post: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        title: const Text('New travel tale', style: TextStyle(color: AppColors.ink)),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _imageDataUri == null
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 36, color: AppColors.teal),
                              SizedBox(height: 8),
                              Text('Tap to browse your photos', style: TextStyle(color: AppColors.charcoal)),
                            ],
                          ),
                        )
                      : PostImage(source: _imageDataUri!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Caption',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorText!,
                style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Share travel tale', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
