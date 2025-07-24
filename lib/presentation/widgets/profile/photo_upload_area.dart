import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final containerSize = screenWidth * 0.33; // %33 of screen width

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: 165, // Fixed height as per design
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
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
      borderRadius: BorderRadius.circular(30), // Slightly less than container
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
        AssetConstants.iconAdd, // You'll need to provide this SVG
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(
          Colors.white.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
