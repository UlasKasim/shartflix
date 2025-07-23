import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/theme/app_theme.dart';
import 'dart:ui';

import '../../../core/constants/asset_constants.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(32),
      ),
      child: ColoredBox(
        color: AppTheme.backgroundDark,
        child: Stack(
          children: [
            // Top Blur Effect - positioned relative to the modal content
            Positioned(
              top: -20,
              left: MediaQuery.of(context).size.width * 0.25,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 216, sigmaY: 216),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Blur Effect - positioned relative to modal content
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Title - "Sınırlı Teklif"
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
                        const Text(
                          'Jeton paketi\'ni seçerek bonus\n kazanın ve yeni bölümlerin kilidini açın!',
                          style: TextStyle(
                            fontFamily: AssetConstants.fontEuclidCircularA,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5, // 18px / 12px = 1.5
                            letterSpacing: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Bonuses Container
                        _buildBonusesContainer(context),

                        const SizedBox(height: 16),

                        // "Kilidi açmak için bir jeton paketi seçin"
                        const Text(
                          'Kilidi açmak için bir jeton paketi seçin',
                          style: TextStyle(
                            fontFamily: AssetConstants.fontEuclidCircularA,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Token Packages
                        _buildTokenPackages(),

                        const SizedBox(height: 16),

                        // Bottom Button
                        _buildBottomButton(context),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusesContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // "Alacağınız Bonuslar"
          const Text(
            'Alacağınız Bonuslar',
            style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBonusItem(
                  AssetConstants.offerDiamond, 'Premium\nHesap', 33),
              _buildBonusItem(AssetConstants.offerMultipleHearts,
                  'Daha Fazla\nEşleşme', 39),
              _buildBonusItem(AssetConstants.offerMushroom, 'Öne\nÇıkarma', 33),
              _buildBonusItem(
                  AssetConstants.offerHeart, 'Daha Fazla\nBeğeni', 33),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBonusItem(String iconName, String title, double iconSize) {
    return Column(
      children: [
        // Circle with icon
        SizedBox(
          width: 55,
          height: 55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SvgPicture.asset(
                AssetConstants.offerCircle,
                width: 55,
                height: 55,
              ),
              // Icon
              Image.asset(
                iconName,
                width: iconSize,
                height: iconSize,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Title
        Text(
          title,
          style: const TextStyle(
            fontFamily: AssetConstants.fontEuclidCircularA,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.5, // 18px / 12px = 1.5
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTokenPackages() {
    return Row(
      children: [
        // Left package - +10%
        Expanded(
          child: _buildTokenPackage(
            '+10%',
            '200',
            '330',
            '₺99,99',
            'Başına haftalık',
            const [Color(0xFF6F060B), Color(0xFFE50914)],
            const Color(0xFFE50914),
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
            'Başına haftalık',
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
            'Başına haftalık',
            const [Color(0xFF6F060B), Color(0xFFE50914)],
            const Color(0xFFE50914),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: gradientColors,
        ),
      ),
      child: Column(
        children: [
          // Percentage Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 8.33,
                ),
              ],
            ),
            child: Text(
              percentage,
              style: const TextStyle(
                fontFamily: AssetConstants.fontEuclidCircularA,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.5, // 18px / 12px = 1.5
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Old amount (strikethrough)
          Text(
            oldAmount,
            style: const TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.0,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // New amount (big)
          Text(
            newAmount,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // "Jeton" text
          const Text(
            'Jeton',
            style: TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Price
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: AssetConstants.fontEuclidCircularA,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.5, // 18px / 12px = 1.5
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        child: const Text(
          'Tüm Jetonları Gör',
          style: TextStyle(
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
