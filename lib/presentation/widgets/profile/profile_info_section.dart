import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../routes/app_router.dart';
import '../home/custom_cached_image.dart';
import '../common/primary_button.dart';

class ProfileInfoSection extends StatelessWidget {
  final AuthState authState;

  const ProfileInfoSection({
    super.key,
    required this.authState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: _buildUserInfo(context),
          ),

          // Upload Photo Button
          _buildUploadButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final photoUrl = authState is AuthAuthenticated
        ? (authState as AuthAuthenticated).user.photoUrl ?? ''
        : '';

    return Container(
      width: 62,
      height: 62,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: CustomCachedImage(
          imageUrl: photoUrl,
          width: 62,
          height: 62,
          fit: BoxFit.cover,
          errorWidget: _buildDefaultAvatar(),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
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
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final user = authState is AuthAuthenticated
        ? (authState as AuthAuthenticated).user
        : null;

    final displayName = user?.name ?? user?.email ?? 'User';
    final userId = user?.id?.substring(0, 6) ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'ID: $userId',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return PrimaryButton.small(
      text: context.l10n.uploadPhoto,
      onPressed: () {
        context.goNamed(RouteNames.photoUpload);
      },
    );
  }
}
