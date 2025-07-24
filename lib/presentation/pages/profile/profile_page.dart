import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shartflix/core/core.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  void _loadFavoriteMovies() {
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
            ProfileHeader(
              title: context.l10n.profileDetail,
            ),

            const SizedBox(height: 24),

            // Profile Info
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return ProfileInfoSection(
                  authState: authState,
                );
              },
            ),

            const SizedBox(height: 32),

            // Favorite Movies Section
            Expanded(
              child: FavoriteMoviesSection(
                onRefresh: _loadFavoriteMovies,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
