import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:shartflix/core/constants/constants.dart';
import 'package:shartflix/core/extensions/extensions.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/routes/routes.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationPage>(
      builder: (context, currentPage) {
        final bool isHome = currentPage == NavigationPage.home;
        final bool isProfile = currentPage == NavigationPage.profile;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context: context,
              iconPath: AssetConstants.iconHome,
              label: context.l10n.home,
              isSelected: isHome,
              onTap: () {
                if (!isHome) {
                  context
                      .read<NavigationCubit>()
                      .setCurrentPage(NavigationPage.home);
                  context.goNamed(RouteNames.home);
                }
              },
            ),
            const SizedBox(width: 16),
            _buildNavButton(
              context: context,
              iconPath: AssetConstants.iconProfile,
              label: context.l10n.profile,
              isSelected: isProfile,
              onTap: () {
                if (!isProfile) {
                  context
                      .read<NavigationCubit>()
                      .setCurrentPage(NavigationPage.profile);
                  context.goNamed(RouteNames.profile);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.33,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.textPrimary.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
        color: isSelected
            ? AppTheme.textPrimary.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppTheme.primaryRed : AppTheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
