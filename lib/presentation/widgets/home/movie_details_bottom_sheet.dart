import 'package:flutter/material.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/core/utils/responsive_helper.dart';
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
    final r = context.responsive;

    return DraggableScrollableSheet(
      initialChildSize: r.responsive(
        mobile: 0.85,
        tablet: 0.9,
        largeTablet: 0.95,
      ),
      minChildSize: r.responsive(
        mobile: 0.5,
        tablet: 0.6,
        largeTablet: 0.7,
      ),
      maxChildSize: r.responsive(
        mobile: 0.95,
        tablet: 0.98,
        largeTablet: 0.98,
      ),
      builder: (context, scrollController) {
        return Container(
          width: double.infinity, // Full width'i zorla
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(r.cardBorderRadius + 8),
            ),
          ),
          child: Column(
            children: [
              // Handle
              _buildHandle(r),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: r.horizontalPadding,
                    vertical: r.verticalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with poster and basic info
                      MovieDetailsHeader(movie: movie),

                      SizedBox(height: r.largeSpacing),

                      // Description
                      _buildDescriptionSection(context, r),

                      SizedBox(height: r.largeSpacing),

                      // Images Gallery
                      if (movie.images != null && movie.images!.isNotEmpty) ...[
                        MovieDetailsSection(
                          title: context.l10n.gallery,
                          child: MovieImagesGallery(images: movie.images!),
                        ),
                        SizedBox(height: r.largeSpacing),
                      ],

                      // Movie Details
                      _buildMovieDetailsSection(context, r),

                      SizedBox(height: r.largeSpacing),

                      // Cast & Crew
                      if (_hasCastAndCrew()) ...[
                        _buildCastAndCrewSection(context, r),
                        SizedBox(height: r.largeSpacing),
                      ],

                      // Ratings & Awards
                      if (_hasRatingsAndAwards()) ...[
                        _buildRatingsAndAwardsSection(context, r),
                        SizedBox(height: r.largeSpacing),
                      ],

                      // Bottom padding for safe scrolling
                      SizedBox(height: r.extraLargeSpacing + 50),
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

  Widget _buildHandle(ResponsiveHelper r) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: r.mediumSpacing),
      width: r.responsive(mobile: 40, tablet: 60),
      height: r.responsive(mobile: 4, tablet: 6),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ResponsiveHelper r) {
    return MovieDetailsSection(
      title: context.l10n.description,
      child: Text(
        movie.description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: r.bodyFontSize,
              height: 1.5,
            ),
      ),
    );
  }

  Widget _buildMovieDetailsSection(BuildContext context, ResponsiveHelper r) {
    return MovieDetailsSection(
      title: context.l10n.movieDetails,
      child: Column(
        children: [
          _buildDetailRow(context, r, context.l10n.year, movie.year),
          _buildDetailRow(context, r, context.l10n.genre, movie.genre),
          if (movie.runtime != null)
            _buildDetailRow(context, r, context.l10n.runtime, movie.runtime!),
          if (movie.rated != null)
            _buildDetailRow(context, r, context.l10n.rated, movie.rated!),
          if (movie.language != null)
            _buildDetailRow(context, r, context.l10n.language, movie.language!),
          if (movie.country != null)
            _buildDetailRow(context, r, context.l10n.country, movie.country!),
          if (movie.released != null)
            _buildDetailRow(context, r, context.l10n.released, movie.released!),
        ],
      ),
    );
  }

  Widget _buildCastAndCrewSection(BuildContext context, ResponsiveHelper r) {
    return MovieDetailsSection(
      title: context.l10n.castAndCrew,
      child: Column(
        children: [
          if (movie.director != null)
            _buildDetailRow(context, r, context.l10n.director, movie.director!),
          if (movie.writer != null)
            _buildDetailRow(context, r, context.l10n.writer, movie.writer!),
          if (movie.actors != null)
            _buildDetailRow(context, r, context.l10n.cast, movie.actors!),
        ],
      ),
    );
  }

  Widget _buildRatingsAndAwardsSection(
      BuildContext context, ResponsiveHelper r) {
    return MovieDetailsSection(
      title: context.l10n.ratingsAndAwards,
      child: Column(
        children: [
          if (movie.imdbRating != null)
            _buildRatingRow(
              context,
              r,
              context.l10n.imdbRating,
              movie.imdbRating!,
              movie.imdbVotes,
            ),
          if (movie.metascore != null)
            _buildDetailRow(
              context,
              r,
              context.l10n.metascore,
              '${movie.metascore!}/100',
            ),
          if (movie.awards != null)
            _buildDetailRow(context, r, context.l10n.awards, movie.awards!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    ResponsiveHelper r,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: r.smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: r.responsive(mobile: 120, tablet: 150),
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: r.bodyFontSize,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: r.bodyFontSize,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(
    BuildContext context,
    ResponsiveHelper r,
    String label,
    String rating,
    String? votes,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: r.smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: r.responsive(mobile: 120, tablet: 150),
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: r.bodyFontSize,
                  ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: r.mediumIconSize,
                ),
                SizedBox(width: r.smallSpacing / 2),
                Text(
                  rating,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: r.bodyFontSize,
                      ),
                ),
                Text(
                  '/10',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: r.captionFontSize,
                      ),
                ),
                if (votes != null) ...[
                  SizedBox(width: r.smallSpacing),
                  Flexible(
                    child: Text(
                      '($votes)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: r.captionFontSize,
                          ),
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
