import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'dart:ui';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../domain/entities/movie_entity.dart';
import 'custom_cached_image.dart';

class FeaturedMovieSection extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggled;

  const FeaturedMovieSection({
    super.key,
    required this.movie,
    required this.onFavoriteToggled,
  });

  void _showMovieDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MovieDetailsBottomSheet(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundDark, // Fallback color
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CustomCachedImage(
              imageUrl: movie.posterUrl,
              fit: BoxFit.cover,
              errorWidget: FallbackImage(
                width: double.infinity,
                height: double.infinity,
                icon: Icons.movie_outlined,
                text: movie.title,
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

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Content Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Favorite Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildFavoriteButton(),
                      ),

                      const SizedBox(height: 16),

                      // Movie Info Row
                      _buildMovieInfoRow(context),

                      const SizedBox(
                          height: 120), // Space for bottom navigation
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 48,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFavoriteToggled,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: SvgPicture.asset(
                  AssetConstants.iconFavorite,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    movie.isFavorite ? AppTheme.primaryRed : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfoRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetConstants.iconLogo,
          height: 40,
          width: 40,
        ),

        const SizedBox(width: 16),

        // Movie Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                movie.title,
                style: const TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              _buildDescriptionWithMore(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionWithMore(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMovieDetails(context),
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const textStyle = TextStyle(
            fontFamily: AssetConstants.fontEuclidCircularA,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.0,
          );

          const moreStyle = TextStyle(
            fontFamily: AssetConstants.fontEuclidCircularA,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.0,
          );

          if (movie.description.length > 50) {
            final textPainter = TextPainter(
              text: TextSpan(text: movie.description, style: textStyle),
              maxLines: 2,
              textDirection: TextDirection.ltr,
            );

            textPainter.layout(maxWidth: constraints.maxWidth);

            if (textPainter.didExceedMaxLines) {
              // Text exceeds 2 lines, need to truncate
              final words = movie.description.split(' ');
              String truncatedText = '';

              // Find the right place to cut
              for (int i = 0; i < words.length; i++) {
                final testText = words.sublist(0, i + 1).join(' ');
                final testPainter = TextPainter(
                  text: TextSpan(
                      text: '$testText ${context.l10n.more}', style: textStyle),
                  maxLines: 2,
                  textDirection: TextDirection.ltr,
                );
                testPainter.layout(maxWidth: constraints.maxWidth);

                if (testPainter.didExceedMaxLines) {
                  break;
                }
                truncatedText = testText;
              }

              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: truncatedText,
                      style: textStyle,
                    ),
                    TextSpan(
                      text: ' ${context.l10n.more}',
                      style: moreStyle,
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.description,
                    style: textStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.more,
                    style: moreStyle,
                  ),
                ],
              );
            }
          } else {
            // Short text, still tappable
            return Text(
              movie.description,
              style: textStyle,
              maxLines: 2,
            );
          }
        },
      ),
    );
  }
}

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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with poster and basic info
                      _buildHeader(context),

                      const SizedBox(height: 24),

                      // Description
                      _buildSection(
                        context.l10n.description,
                        Text(
                          movie.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Images Gallery
                      if (movie.images != null && movie.images!.isNotEmpty) ...[
                        _buildSection(
                          context.l10n.gallery,
                          _buildImageGallery(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Movie Details
                      _buildSection(
                        context.l10n.movieDetails,
                        Column(
                          children: [
                            _buildDetailRow(context.l10n.year, movie.year),
                            _buildDetailRow(context.l10n.genre, movie.genre),
                            if (movie.runtime != null)
                              _buildDetailRow(
                                  context.l10n.runtime, movie.runtime!),
                            if (movie.rated != null)
                              _buildDetailRow(context.l10n.rated, movie.rated!),
                            if (movie.language != null)
                              _buildDetailRow(
                                  context.l10n.language, movie.language!),
                            if (movie.country != null)
                              _buildDetailRow(
                                  context.l10n.country, movie.country!),
                            if (movie.released != null)
                              _buildDetailRow(
                                  context.l10n.released, movie.released!),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Cast & Crew
                      if (movie.director != null ||
                          movie.writer != null ||
                          movie.actors != null) ...[
                        _buildSection(
                          context.l10n.castAndCrew,
                          Column(
                            children: [
                              if (movie.director != null)
                                _buildDetailRow(
                                    context.l10n.director, movie.director!),
                              if (movie.writer != null)
                                _buildDetailRow(
                                    context.l10n.writer, movie.writer!),
                              if (movie.actors != null)
                                _buildDetailRow(
                                    context.l10n.cast, movie.actors!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Ratings & Awards
                      if (movie.imdbRating != null ||
                          movie.metascore != null ||
                          movie.awards != null) ...[
                        _buildSection(
                          context.l10n.ratingsAndAwards,
                          Column(
                            children: [
                              if (movie.imdbRating != null)
                                _buildRatingRow(context.l10n.imdbRating,
                                    movie.imdbRating!, movie.imdbVotes),
                              if (movie.metascore != null)
                                _buildDetailRow(context.l10n.metascore,
                                    '${movie.metascore!}/100'),
                              if (movie.awards != null)
                                _buildDetailRow(
                                    context.l10n.awards, movie.awards!),
                            ],
                          ),
                        ),
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

  Widget _buildHeader(BuildContext context) {
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
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),

              const SizedBox(height: 8),

              // Year, Runtime, Rating badges
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      movie.year,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (movie.runtime != null)
                    Text(
                      movie.runtime!,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  if (movie.rated != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.textSecondary),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        movie.rated!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // IMDb Rating
              if (movie.imdbRating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      movie.imdbRating!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '/10',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (movie.imdbVotes != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '(${movie.imdbVotes!})',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: AssetConstants.fontEuclidCircularA,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, String rating, String? votes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  '/10',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (votes != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '($votes)',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
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

  Widget _buildImageGallery() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movie.images!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomCachedImage(
                imageUrl: movie.images![index],
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
