// Header section with poster and basic movie info
import 'package:flutter/material.dart';
import 'package:shartflix/core/theme/app_theme.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';

import 'custom_cached_image.dart';

class MovieDetailsHeader extends StatelessWidget {
  final MovieEntity movie;

  const MovieDetailsHeader({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomCachedImage(
            imageUrl: movie.posterUrl,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
            errorWidget: const FallbackImage(
              width: 100,
              height: 150,
              icon: Icons.movie_outlined,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Title and basic info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),

              const SizedBox(height: 8),

              // Year, Runtime, Rating badges
              _buildBadges(context),

              const SizedBox(height: 12),

              // IMDb Rating
              if (movie.imdbRating != null) _buildImdbRating(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadges(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            movie.year,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        if (movie.runtime != null)
          Text(
            movie.runtime!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        if (movie.rated != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.textSecondary),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              movie.rated!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildImdbRating(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          movie.imdbRating!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '/10',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (movie.imdbVotes != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '(${movie.imdbVotes!})',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
