import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/core/utils/responsive_helper.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class FavoriteMoviesSection extends StatelessWidget {
  final VoidCallback onRefresh;

  const FavoriteMoviesSection({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        _buildSectionTitle(context, r),

        SizedBox(height: r.largeSpacing),

        // Movies Grid
        Expanded(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              return _buildContent(context, state, r);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, ResponsiveHelper r) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
      child: Text(
        context.l10n.moviesILike,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: r.responsive(mobile: 13, tablet: 16),
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MovieState state,
    ResponsiveHelper r,
  ) {
    if (state is MovieFavoritesLoaded) {
      if (state.favorites.isEmpty) {
        return _buildEmptyState(context, r);
      }
      return _buildMoviesGrid(state.favorites, r);
    }

    if (state is MovieFavoritesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MovieFavoritesError) {
      return _buildErrorState(context, state.message, r);
    }

    return _buildErrorState(context, context.l10n.moviesCouldNotLoaded, r);
  }

  Widget _buildEmptyState(BuildContext context, ResponsiveHelper r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: r.responsive(mobile: 64, tablet: 80),
            color: Colors.white54,
          ),
          SizedBox(height: r.mediumSpacing),
          Text(
            context.l10n.noFavoriteMovies,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: r.bodyFontSize,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    ResponsiveHelper r,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: r.responsive(mobile: 64, tablet: 80),
            color: Colors.white54,
          ),
          SizedBox(height: r.mediumSpacing),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: r.bodyFontSize,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: r.mediumSpacing),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(List<MovieEntity> movies, ResponsiveHelper r) {
    // Responsive grid configuration
    final int crossAxisCount = r.responsive(
      mobile: 2, // Mobilde 2 sütun
      tablet: 3, // Tablet'te 3 sütun
      largeTablet: 4, // Büyük tablet'te 4 sütun
    );

    return Padding(
      padding: EdgeInsets.only(
        left: r.horizontalPadding,
        right: r.horizontalPadding,
        bottom: r.responsive(mobile: 70, tablet: 90), // Bottom nav için boşluk
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.55,
          crossAxisSpacing: r.gridSpacing,
          mainAxisSpacing: r.gridSpacing,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return ResponsiveMovieCard(
            movie: movies[index],
            onTap: () {
              // Navigate to movie details - bu kısmı da bottom sheet açacak şekilde yapabiliriz
              _showMovieDetails(context, movies[index]);
            },
          );
        },
      ),
    );
  }

  void _showMovieDetails(BuildContext context, MovieEntity movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      constraints: const BoxConstraints.expand(),
      builder: (context) => MovieDetailsBottomSheet(movie: movie),
    );
  }
}

// Responsive Movie Card
class ResponsiveMovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const ResponsiveMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r.cardBorderRadius),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            _buildPoster(r),

            // Movie Info
            _buildMovieInfo(context, r),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(ResponsiveHelper r) {
    return AspectRatio(
      aspectRatio: 0.71,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r.cardBorderRadius),
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

  Widget _buildMovieInfo(BuildContext context, ResponsiveHelper r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: r.mediumSpacing),
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
                  fontSize: r.responsive(mobile: 12, tablet: 14),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: r.smallSpacing / 2),

          // Director
          Text(
            movie.director ?? '',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: r.captionFontSize,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
