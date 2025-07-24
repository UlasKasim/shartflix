import 'package:flutter/material.dart';
import 'package:shartflix/core/services/navigation_service.dart';
import 'package:shartflix/core/injection/injection_container.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/presentation/widgets/home/home.dart';

class FeaturedMovieSection extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onFavoriteToggled;

  const FeaturedMovieSection({
    super.key,
    required this.movie,
    required this.onFavoriteToggled,
  });

  void _showMovieDetails(BuildContext context) {
    sl<NavigationService>().showCustomBottomSheet(
      child: MovieDetailsBottomSheet(movie: movie),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundDark,
      ),
      child: Stack(
        children: [
          // Background Image with Gradient
          MovieBackground(
            imageUrl: movie.posterUrl,
            title: movie.title,
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
                      MovieFavoriteButton(
                        isFavorite: movie.isFavorite,
                        onToggle: onFavoriteToggled,
                      ),

                      const SizedBox(height: 16),

                      // Movie Info
                      MovieInfoSection(
                        movie: movie,
                        onMoreTap: () => _showMovieDetails(context),
                      ),

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
}
