import 'package:flutter/material.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/presentation/widgets/home/home.dart';

class MovieDetailsBottomSheet extends StatelessWidget {
  final MovieEntity movie;

  const MovieDetailsBottomSheet({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              _buildHandle(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with poster and basic info
                      MovieDetailsHeader(movie: movie),

                      const SizedBox(height: 24),

                      // Description
                      _buildDescriptionSection(context),

                      const SizedBox(height: 24),

                      // Images Gallery
                      if (movie.images != null && movie.images!.isNotEmpty) ...[
                        MovieDetailsSection(
                          title: context.l10n.gallery,
                          child: MovieImagesGallery(images: movie.images!),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Movie Details
                      _buildMovieDetailsSection(context),

                      const SizedBox(height: 24),

                      // Cast & Crew
                      if (_hasCastAndCrew()) ...[
                        _buildCastAndCrewSection(context),
                        const SizedBox(height: 24),
                      ],

                      // Ratings & Awards
                      if (_hasRatingsAndAwards()) ...[
                        _buildRatingsAndAwardsSection(context),
                        const SizedBox(height: 24),
                      ],

                      // Bottom padding for safe scrolling
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.textPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return MovieDetailsSection(
      title: context.l10n.description,
      child: Text(
        movie.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
      ),
    );
  }

  Widget _buildMovieDetailsSection(BuildContext context) {
    return MovieDetailsSection(
      title: context.l10n.movieDetails,
      child: Column(
        children: [
          _buildDetailRow(context, context.l10n.year, movie.year),
          _buildDetailRow(context, context.l10n.genre, movie.genre),
          if (movie.runtime != null)
            _buildDetailRow(context, context.l10n.runtime, movie.runtime!),
          if (movie.rated != null)
            _buildDetailRow(context, context.l10n.rated, movie.rated!),
          if (movie.language != null)
            _buildDetailRow(context, context.l10n.language, movie.language!),
          if (movie.country != null)
            _buildDetailRow(context, context.l10n.country, movie.country!),
          if (movie.released != null)
            _buildDetailRow(context, context.l10n.released, movie.released!),
        ],
      ),
    );
  }

  Widget _buildCastAndCrewSection(BuildContext context) {
    return MovieDetailsSection(
      title: context.l10n.castAndCrew,
      child: Column(
        children: [
          if (movie.director != null)
            _buildDetailRow(context, context.l10n.director, movie.director!),
          if (movie.writer != null)
            _buildDetailRow(context, context.l10n.writer, movie.writer!),
          if (movie.actors != null)
            _buildDetailRow(context, context.l10n.cast, movie.actors!),
        ],
      ),
    );
  }

  Widget _buildRatingsAndAwardsSection(BuildContext context) {
    return MovieDetailsSection(
      title: context.l10n.ratingsAndAwards,
      child: Column(
        children: [
          if (movie.imdbRating != null)
            _buildRatingRow(
              context,
              context.l10n.imdbRating,
              movie.imdbRating!,
              movie.imdbVotes,
            ),
          if (movie.metascore != null)
            _buildDetailRow(
              context,
              context.l10n.metascore,
              '${movie.metascore!}/100',
            ),
          if (movie.awards != null)
            _buildDetailRow(context, context.l10n.awards, movie.awards!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(
    BuildContext context,
    String label,
    String rating,
    String? votes,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '/10',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (votes != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '($votes)',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasCastAndCrew() {
    return movie.director != null ||
        movie.writer != null ||
        movie.actors != null;
  }

  bool _hasRatingsAndAwards() {
    return movie.imdbRating != null ||
        movie.metascore != null ||
        movie.awards != null;
  }
}
