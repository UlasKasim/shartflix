import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/app_theme.dart';
import 'dart:ui';

import '../../../core/constants/asset_constants.dart';

class LimitedOfferBottomSheet extends StatefulWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  State<LimitedOfferBottomSheet> createState() =>
      _LimitedOfferBottomSheetState();
}

class _LimitedOfferBottomSheetState extends State<LimitedOfferBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        child: ColoredBox(
          color: AppTheme.backgroundDark,
          child: Stack(
            children: [
              // Top Blur Effect
              Positioned(
                top: -20,
                left: MediaQuery.of(context).size.width * 0.25,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.width * 0.55,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Blur Effect
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.5 - 108,
                child: Container(
                  width: 216,
                  height: 216,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      context.l10n.limitedOffer,
                      style: const TextStyle(
                        fontFamily: AssetConstants.fontEuclidCircularA,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      context.l10n.limitedOfferDescription,
                      style: const TextStyle(
                        fontFamily: AssetConstants.fontEuclidCircularA,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Bonuses Container
                    _buildBonusesContainer(context),

                    const SizedBox(height: 16),

                    // Token Package Selection Prompt
                    Text(
                      context.l10n.selectTokenPackage,
                      style: const TextStyle(
                        fontFamily: AssetConstants.fontEuclidCircularA,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Token Packages
                    _buildTokenPackages(context),

                    const SizedBox(height: 16),

                    // Bottom Button
                    _buildBottomButton(context),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonusesContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
      ),
      child: Column(
        children: [
          // Bonuses Title
          Text(
            context.l10n.bonusesTitle,
            style: const TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.0,
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 24),

          // Bonus Items Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBonusItem(
                  AssetConstants.offerDiamond, context.l10n.premiumAccount, 33),
              _buildBonusItem(AssetConstants.offerMultipleHearts,
                  context.l10n.moreMatches, 39),
              _buildBonusItem(
                  AssetConstants.offerMushroom, context.l10n.highlight, 33),
              _buildBonusItem(
                  AssetConstants.offerHeart, context.l10n.moreLikes, 33),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBonusItem(String iconName, String title, double iconSize) {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 0.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 9,
                  spreadRadius: -8,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 6,
                  spreadRadius: -5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AssetConstants.offerCircle,
                  width: 55,
                  height: 55,
                ),
                Image.asset(
                  iconName,
                  width: iconSize,
                  height: iconSize,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.5,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTokenPackages(BuildContext context) {
    return Row(
      children: [
        // Left package - +10%
        Expanded(
          child: _buildTokenPackage(
            '+10%',
            '200',
            '330',
            '₺99,99',
            context.l10n.perWeek,
            const [Color(0xFF6F060B), Color(0xFFE50914)],
            const Color(0xFF6F060B),
          ),
        ),
        const SizedBox(width: 12),
        // Middle package - +70%
        Expanded(
          child: _buildTokenPackage(
            '+70%',
            '2.000',
            '3.375',
            '₺799,99',
            context.l10n.perWeek,
            const [Color(0xFF5949E6), Color(0xFFE50914)],
            const Color(0xFF5949E6),
          ),
        ),
        const SizedBox(width: 12),
        // Right package - +35%
        Expanded(
          child: _buildTokenPackage(
            '+35%',
            '1.000',
            '1.350',
            '₺399,99',
            context.l10n.perWeek,
            const [Color(0xFF6F060B), Color(0xFFE50914)],
            const Color(0xFF6F060B),
          ),
        ),
      ],
    );
  }

  Widget _buildTokenPackage(
    String percentage,
    String oldAmount,
    String newAmount,
    String price,
    String subtitle,
    List<Color> gradientColors,
    Color badgeColor,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 28, 12, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            gradient: RadialGradient(
              center: const Alignment(-0.7, -0.7),
              radius: 1.5,
              colors: gradientColors,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text(
                oldAmount,
                style: const TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                newAmount,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.tokenLabel,
                style: const TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: AssetConstants.fontEuclidCircularA,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Positioned(
          top: -12.5,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 25,
              width: 61,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12.5),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 8.33,
                    spreadRadius: -4,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: -8,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 8.33,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontFamily: AssetConstants.fontEuclidCircularA,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Text(
          context.l10n.viewAllTokens,
          style: const TextStyle(
            fontFamily: AssetConstants.fontEuclidCircularA,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
