import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/asset_constants.dart';

class PhotoUploadHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;

  const PhotoUploadHeader({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Back Button
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onBackPressed,
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
              ),
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

          // Empty space to balance the layout
          const Expanded(flex: 6, child: SizedBox()),
        ],
      ),
    );
  }
}
