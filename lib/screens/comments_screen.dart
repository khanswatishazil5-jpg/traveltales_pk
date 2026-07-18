import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/comment_model.dart';
import '../services/comment_repository.dart';
import '../services/auth_service.dart';

/// Opens as a modal bottom sheet from the Feed's comment button.
Future<void> showCommentsSheet(BuildContext context, {required String postId}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.paper,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CommentsSheet(postId: postId),
  );
}

class CommentsSheet extends StatefulWidget {
  final String postId;
  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _repository = CommentRepository();
  final _authService = AuthService();
  final _controller = TextEditingController();

  List<CommentModel> _comments = [];
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final comments = await _repository.getCommentsFor(widget.postId);
    if (!mounted) return;
    setState(() {
      _comments = comments;
      _loading = false;
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      final profile = await _authService.getProfile();
      final comment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.postId,
        username: profile?.username ?? 'you',
        text: text,
        createdAt: DateTime.now(),
      );
      await _repository.addComment(comment);
      _controller.clear();
      await _load();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Comments', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.ink)),
            const Divider(color: AppColors.line, height: 24),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? const Center(
                          child: Text('No comments yet — be the first to say something.', style: TextStyle(color: AppColors.charcoal)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _comments.length,
                          itemBuilder: (context, i) {
                            final c = _comments[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.teal,
                                    child: Text(
                                      c.username.length >= 2 ? c.username.substring(0, 2).toUpperCase() : c.username.toUpperCase(),
                                      style: const TextStyle(color: AppColors.paper, fontSize: 11, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.username, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink, fontSize: 13)),
                                        const SizedBox(height: 2),
                                        Text(c.text, style: const TextStyle(color: AppColors.charcoal)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: 'Add a comment...'),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sending ? null : _send,
                      icon: const Icon(Icons.send, color: AppColors.coral),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
