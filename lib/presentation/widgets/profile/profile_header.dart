import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/core.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onOfferTap;

  const ProfileHeader({
    super.key,
    required this.title,
    this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Row(
        children: [
          // Back Button
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildBackButton(),
            ),
          ),

          // Title
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),

          // Limited Offer Button
          Expanded(
            flex: 6,
            child: _buildLimitedOfferButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildLimitedOfferButton(BuildContext context) {
    return GestureDetector(
      onTap: onOfferTap ??
          () {
            sl<NavigationService>().pushBottomSheetOverlay(
              const LimitedOfferBottomSheet(),
            );
          },
      child: Container(
        height: 33,
        decoration: BoxDecoration(
          color: AppTheme.primaryRed,
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: AssetConstants.montserrat,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
