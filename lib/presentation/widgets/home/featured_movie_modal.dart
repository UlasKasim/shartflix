import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../domain/entities/movie_entity.dart';
import 'custom_cached_image.dart';

class FeaturedMovieModal extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggled;

  const FeaturedMovieModal({
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
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

          // Black Gradient Overlay at bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.5, 0.7, 0.85, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

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

                      const SizedBox(height: 32),
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
        // Netflix-style logo/icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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

              // Description with "Daha Fazlası" at the end of second line
              _buildDescriptionWithMore(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionWithMore(BuildContext context) {
    return LayoutBuilder(
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

        final textPainter = TextPainter(
          text: TextSpan(text: movie.description, style: textStyle),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          // Text exceeds 2 lines, we need to truncate and add "Daha Fazlası"
          final moreTextPainter = TextPainter(
            text: const TextSpan(text: ' Daha Fazlası', style: moreStyle),
            textDirection: TextDirection.ltr,
          );
          moreTextPainter.layout();

          // Calculate available width for description text
          final availableWidth = constraints.maxWidth - moreTextPainter.width;

          final truncatedTextPainter = TextPainter(
            text: TextSpan(text: movie.description, style: textStyle),
            maxLines: 2,
            textDirection: TextDirection.ltr,
          );
          truncatedTextPainter.layout(maxWidth: availableWidth);

          // Get the truncated text
          final endOffset = truncatedTextPainter
              .getPositionForOffset(
                Offset(availableWidth, truncatedTextPainter.height),
              )
              .offset;

          final truncatedText = movie.description.substring(0, endOffset);

          return GestureDetector(
            onTap: () => _showMovieDetails(context),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.clip,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: truncatedText.trimRight(),
                    style: textStyle,
                  ),
                  const TextSpan(
                    text: ' Daha Fazlası',
                    style: moreStyle,
                  ),
                ],
              ),
            ),
          );
        } else {
          // Text fits in 2 lines, show normally
          return Text(
            movie.description,
            style: textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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

                  const SizedBox(height: 16),

                  Text(
                    movie.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Additional movie info
                  _buildMovieInfoItem('Year', movie.year),
                  _buildMovieInfoItem('Genre', movie.genre),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
