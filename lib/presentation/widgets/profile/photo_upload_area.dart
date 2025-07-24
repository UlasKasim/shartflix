import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/theme/theme.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.4;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: AppTheme.textPrimary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppTheme.textPrimary.withValues(alpha: 0.1),
            width: 1.55,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: selectedImagePath != null
            ? _buildSelectedImage()
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.file(
        File(selectedImagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: SvgPicture.asset(
        AssetConstants.iconAdd,
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(
          AppTheme.textPrimary.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
