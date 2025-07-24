import 'package:flutter/material.dart';

import '../home/custom_cached_image.dart';

class MovieBackground extends StatelessWidget {
  final String imageUrl;
  final String title;

  const MovieBackground({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: FallbackImage(
              width: double.infinity,
              height: double.infinity,
              icon: Icons.movie_outlined,
              text: title,
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.4, 0.8, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
