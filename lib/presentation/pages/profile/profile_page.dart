import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/presentation/widgets/home/limited_offer_bottom_sheet.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../widgets/home/custom_cached_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFavoriteMovies() {
    // Load favorite movies using the dedicated service
    context.read<MovieBloc>().add(MovieFavoritesLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            const SizedBox(height: 24),

            // Profile Info
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return _buildProfileInfo(context, authState);
              },
            ),

            const SizedBox(height: 32),

            // Favorite Movies Section
            Expanded(
              child: _buildFavoriteMoviesSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetConstants.iconArrowLeft,
                      width: 15,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                context.l10n.profileDetail,
                style: const TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const LimitedOfferBottomSheet(),
                );
              },
              child: Container(
                height: 33,
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914),
                  borderRadius: BorderRadius.circular(53),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      AssetConstants.iconOffer,
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.limitedOffer,
                      style: const TextStyle(
                        fontFamily: AssetConstants.montserrat,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, AuthState authState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35), // Updated padding
      child: Row(
        children: [
          // Avatar
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CustomCachedImage(
                imageUrl: authState is AuthAuthenticated
                    ? (authState.user.photoUrl ?? '')
                    : '',
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    color: AppTheme.cardDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // User Info from AuthBloc
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authState is AuthAuthenticated
                      ? (authState.user.name ?? authState.user.email ?? 'User')
                      : '',
                  style: const TextStyle(
                    fontFamily: AssetConstants.fontEuclidCircularA,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authState is AuthAuthenticated
                      ? 'ID: ${authState.user.id?.substring(0, 6) ?? 'N/A'}'
                      : 'ID: N/A',
                  style: const TextStyle(
                    fontFamily: AssetConstants.fontEuclidCircularA,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Add Photo Button
          GestureDetector(
            onTap: () {
              // Handle photo upload
              _handlePhotoUpload();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                context.l10n.uploadPhoto,
                style: const TextStyle(
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
      ),
    );
  }

  void _handlePhotoUpload() {
    // TODO: Implement photo upload
  }

  Widget _buildFavoriteMoviesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 40), // Updated padding
          child: Text(
            context.l10n.moviesILike,
            style: const TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Movies Grid
        Expanded(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieFavoritesLoaded) {
                if (state.favorites.isEmpty) {
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
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 40, // Updated padding
                    right: 40, // Updated padding
                    bottom: 120,
                  ),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) {
                      final movie = state.favorites[index];
                      return _buildMovieCard(movie);
                    },
                  ),
                );
              }

              if (state is MovieFavoritesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is MovieFavoritesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return Center(
                child: Text(
                  context.l10n.moviesCouldNotLoaded,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(MovieEntity movie) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie details or open modal
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with 0.71 aspect ratio
            AspectRatio(
              aspectRatio: 0.71,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16),
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
                    movie.director ?? '',
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
          ],
        ),
      ),
    );
  }
}
