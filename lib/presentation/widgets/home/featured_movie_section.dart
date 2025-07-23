import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

                      const SizedBox(height: 32),

                      // Bottom padding for navigation bar
                      const SizedBox(height: 72), // 40px height + 32px spacing
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
      borderRadius: BorderRadius.circular(20), // Spacing/20
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 48,
          height: 60, // Dikey oval
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2), // Saydam/%20 Siyah
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2), // Saydam/%20 Beyaz
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
        // Netflix-style logo/icon (40x40px)
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

              // Description with "Daha Fazlası" option
              _buildDescriptionWithMore(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionWithMore(BuildContext context) {
    const maxLines = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.description,
          style: const TextStyle(
            fontFamily: AssetConstants.fontEuclidCircularA,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.0,
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (movie.description.length > 100) // Approximate check for long text
          GestureDetector(
            onTap: () => _showMovieDetails(context),
            child: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Daha Fazlası',
                style: TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
      ],
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
                  if (movie.director != null)
                    _buildMovieInfoItem('Director', movie.director!),
                  if (movie.actors != null)
                    _buildMovieInfoItem('Cast', movie.actors!),
                  if (movie.runtime != null)
                    _buildMovieInfoItem('Runtime', movie.runtime!),
                  if (movie.rated != null)
                    _buildMovieInfoItem('Rated', movie.rated!),
                  if (movie.language != null)
                    _buildMovieInfoItem('Language', movie.language!),
                  if (movie.country != null)
                    _buildMovieInfoItem('Country', movie.country!),
                  if (movie.imdbRating != null)
                    _buildMovieInfoItem('IMDb Rating', movie.imdbRating!),
                  if (movie.awards != null)
                    _buildMovieInfoItem('Awards', movie.awards!),
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
