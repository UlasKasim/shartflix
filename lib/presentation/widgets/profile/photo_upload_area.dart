import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/theme/theme.dart';
import 'package:shartflix/core/utils/responsive_helper.dart';

import '../../../core/constants/asset_constants.dart';

class PhotoUploadArea extends StatelessWidget {
  final String? selectedImagePath;
  final VoidCallback onTap;

  const PhotoUploadArea({
    super.key,
    this.selectedImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    // Responsive container size
    final double containerSize = r.responsive(
      mobile: MediaQuery.of(context).size.width * 0.4, // Mobilde %40
      tablet: 200, // Tablet'te sabit 200px
      largeTablet: 240, // Büyük tablet'te 240px
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: AppTheme.textPrimary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppTheme.textPrimary.withValues(alpha: 0.1),
            width: r.responsive(mobile: 1.55, tablet: 2.0),
          ),
          borderRadius: BorderRadius.circular(
            r.responsive(mobile: 32, tablet: 40),
          ),
        ),
        child: selectedImagePath != null
            ? _buildSelectedImage(r)
            : _buildPlaceholder(r),
      ),
    );
  }

  Widget _buildSelectedImage(ResponsiveHelper r) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        r.responsive(mobile: 30, tablet: 38),
      ),
      child: Image.file(
        File(selectedImagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildPlaceholder(ResponsiveHelper r) {
    return Center(
      child: SvgPicture.asset(
        AssetConstants.iconAdd,
        width: r.responsive(mobile: 26, tablet: 32),
        height: r.responsive(mobile: 26, tablet: 32),
        colorFilter: ColorFilter.mode(
          AppTheme.textPrimary.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
