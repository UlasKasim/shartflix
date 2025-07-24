import 'package:flutter/material.dart';

import 'custom_cached_image.dart';

class MovieImagesGallery extends StatelessWidget {
  final List<String> images;

  const MovieImagesGallery({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomCachedImage(
                imageUrl: images[index],
                width: 160,
                height: 120,
                fit: BoxFit.cover,
                errorWidget: const FallbackImage(
                  width: 160,
                  height: 120,
                  icon: Icons.image_outlined,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
