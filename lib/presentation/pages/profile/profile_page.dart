import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions/localization_extension.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/injection/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/common/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  void _onPhotoChangePressed() async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.changePhoto,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                    text: context.l10n.camera,
                    icon: Icons.camera_alt_outlined,
                    variant: ButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                    text: context.l10n.gallery,
                    icon: Icons.photo_library_outlined,
                    variant: ButtonVariant.outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      final image = await _imagePicker.pickImage(source: result);
      if (image != null) {
        context.read<ProfileBloc>().add(
              ProfilePhotoUploadRequested(filePath: image.path),
            );
      }
    }
  }

  void _onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        centerTitle: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePhotoUploadSuccess) {
            sl<NavigationService>().showSnackBar(
              context.l10n.photoUploadSuccess,
              type: SnackBarType.success,
            );
            // Refresh user profile
            context.read<AuthBloc>().add(AuthUserProfileRequested());
          } else if (state is ProfilePhotoUploadError) {
            sl<NavigationService>().showSnackBar(
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = authState.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Photo Section
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                      final isUploading = profileState is ProfilePhotoUploading;

                      return Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                              boxShadow: [AppShadows.elevatedShadow.first],
                            ),
                            child: ClipOval(
                              child: user.photoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: user.photoUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          if (isUploading)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black..withValues(alpha: 0.5),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: isUploading ? null : _onPhotoChangePressed,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // User Info
                  Text(
                    user.name ?? "",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? "",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),

                  const SizedBox(height: 40),

                  // Profile Options
                  _buildProfileOption(
                    context,
                    Icons.favorite_outline,
                    context.l10n.favorites,
                    () {
                      // TODO: Navigate to favorites
                    },
                  ),

                  _buildProfileOption(
                    context,
                    Icons.settings_outlined,
                    context.l10n.settings,
                    () {
                      // TODO: Navigate to settings
                    },
                  ),

                  _buildProfileOption(
                    context,
                    Icons.language_outlined,
                    context.l10n.language,
                    () {
                      // TODO: Show language selector
                    },
                  ),

                  _buildProfileOption(
                    context,
                    Icons.info_outline,
                    context.l10n.about,
                    () {
                      // TODO: Show about dialog
                    },
                  ),

                  const SizedBox(height: 40),

                  // Logout Button
                  CustomButton(
                    onPressed: _onLogoutPressed,
                    text: context.l10n.logout,
                    icon: Icons.logout,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    width: double.infinity,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed..withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryRed),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: AppTheme.cardDark,
      ),
    );
  }
}
