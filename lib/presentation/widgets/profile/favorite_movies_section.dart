import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/theme.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        _buildSectionTitle(context),

        const SizedBox(height: 24),

        // Movies Grid
        Expanded(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              return _buildContent(context, state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        context.l10n.moviesILike,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieState state) {
    if (state is MovieFavoritesLoaded) {
      if (state.favorites.isEmpty) {
        return _buildEmptyState(context);
      }
      return _buildMoviesGrid(state.favorites);
    }

    if (state is MovieFavoritesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MovieFavoritesError) {
      return _buildErrorState(context, state.message);
    }

    return _buildErrorState(context, context.l10n.moviesCouldNotLoaded);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noFavoriteMovies,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(List<MovieEntity> movies) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        right: 40,
        bottom: 70,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            movie: movies[index],
            onTap: () {
              // Navigate to movie details
            },
          );
        },
      ),
    );
  }
}
