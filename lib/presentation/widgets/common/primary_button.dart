import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final Widget? icon;
  final MainAxisSize mainAxisSize;

  const PrimaryButton({
    super.key,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.width,
    this.icon,
    this.mainAxisSize = MainAxisSize.max,
  });

  // Factory constructors for common button types
  factory PrimaryButton.auth({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      borderRadius: 18,
      height: 52,
      width: double.infinity,
    );
  }

  factory PrimaryButton.small({
    required String text,
    required VoidCallback onPressed,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return PrimaryButton(
      text: text,
      textStyle: textStyle,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      mainAxisSize: MainAxisSize.min,
    );
  }

  factory PrimaryButton.bottomSheet({
    required String text,
    required VoidCallback onPressed,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return PrimaryButton(
      text: text,
      textStyle: textStyle,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      borderRadius: 18,
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? AppTheme.textPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle ??
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: textColor ?? AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
              ),
            ],
          );

    Widget button = ElevatedButton(
      onPressed: isButtonEnabled ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.primaryRed,
        foregroundColor: textColor ?? AppTheme.textPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        disabledBackgroundColor: AppTheme.cardDark,
        disabledForegroundColor: AppTheme.textHint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        padding: padding ?? EdgeInsets.zero,
        // Disable material design constraints
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: buttonChild,
    );

    // Apply custom size constraints
    if (width != null || height != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}
