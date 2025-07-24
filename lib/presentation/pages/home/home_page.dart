import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shartflix/core/core.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadMovies() {
    context.read<MovieBloc>().add(MovieLoadRequested());
  }

  Future<void> _onRefresh() async {
    context.read<MovieBloc>().add(MovieRefreshRequested());
  }

  void _onMovieFavoriteToggled(String movieId) {
    context.read<MovieBloc>().add(
          MovieToggleFavoriteRequested(movieId: movieId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieLoaded && state.error != null) {
            sl<NavigationService>().showSnackBar(
              state.error!,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.error,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadMovies,
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state is MovieLoaded && state.movies.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  // Load more when reaching near the end
                  if (index >= state.movies.length - 2 &&
                      !state.hasReachedMax &&
                      !state.isLoadingMore) {
                    context.read<MovieBloc>().add(MovieLoadMoreRequested());
                  }
                },
                itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < state.movies.length) {
                    return FeaturedMovieSection(
                      movie: state.movies[index],
                      onFavoriteToggled: () =>
                          _onMovieFavoriteToggled(state.movies[index].id),
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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.noData,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
