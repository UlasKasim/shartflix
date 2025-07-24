import 'package:flutter/material.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';

import '../home/custom_cached_image.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            _buildPoster(),

            // Movie Info
            _buildMovieInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return AspectRatio(
      aspectRatio: 0.71,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomCachedImage(
          imageUrl: movie.posterUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: FallbackImage(
            width: double.infinity,
            icon: Icons.movie_outlined,
            text: movie.title,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Title
          Text(
            movie.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Director
          Text(
            movie.director ?? '',
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
