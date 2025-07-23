import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String svgIconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.svgIconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.transparent10White,
        border: Border.all(
          color: AppTheme.transparent20White,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: SvgPicture.asset(
              svgIconPath,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
