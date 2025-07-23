import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../domain/entities/movie_entity.dart';
import 'custom_cached_image.dart';
import 'featured_movie_modal.dart';

class MoviesGridSection extends StatelessWidget {
  final List<MovieEntity> movies;
  final ScrollController? scrollController;
  final void Function(String movieId) onFavoriteToggled;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const MoviesGridSection({
    super.key,
    required this.movies,
    this.scrollController,
    required this.onFavoriteToggled,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: Colors.white54,
            ),
            SizedBox(height: 16),
            Text(
              'No movies available',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 120, // Bottom navigation + padding
      ),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.71, // 153.13 / 213.82
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length + (isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index < movies.length) {
            return MovieGridCard(
              movie: movies[index],
              onFavoriteToggled: () => onFavoriteToggled(movies[index].id),
              onTap: () => _showFeaturedMovie(context, movies[index]),
            );
          } else {
            // Loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showFeaturedMovie(BuildContext context, MovieEntity movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FeaturedMovieModal(
        movie: movie,
        onFavoriteToggled: () => onFavoriteToggled(movie.id),
      ),
    );
  }
}

class MovieGridCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggled;
  final VoidCallback onTap;

  const MovieGridCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2), // Spacing/2
          color: AppTheme.cardDark,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                    child: CustomCachedImage(
                      imageUrl: movie.posterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: FallbackImage(
                        width: double.infinity,
                        icon: Icons.movie_outlined,
                        text: movie.title,
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggled,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          AssetConstants.iconFavorite,
                          width: 12,
                          height: 12,
                          colorFilter: ColorFilter.mode(
                            movie.isFavorite
                                ? AppTheme.primaryRed
                                : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Movie Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Movie Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontFamily: AssetConstants.fontEuclidCircularA,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Producer/Studio
                    Text(
                      movie.genre, // Using genre as producer for now
                      style: const TextStyle(
                        fontFamily: AssetConstants.fontEuclidCircularA,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
