import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const HeroImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(Icons.error_outline, size: 50),
          ),
        ),
      ),
    );
  }
}
