import 'dart:convert';
import 'package:flutter/material.dart';

const _base64Prefix = 'data:image/';

/// Renders [source] as an image regardless of whether it's a normal
/// network URL (used by the seed/mock posts) or a `data:image/...;base64,`
/// URI (used for anything picked on-device, since there's no backend/object
/// storage yet to upload real files to).
class PostImage extends StatelessWidget {
  final String source;
  final BoxFit fit;

  const PostImage({super.key, required this.source, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (source.startsWith(_base64Prefix)) {
      final commaIndex = source.indexOf(',');
      final bytes = base64Decode(source.substring(commaIndex + 1));
      return Image.memory(bytes, fit: fit);
    }
    return Image.network(source, fit: fit);
  }
}
