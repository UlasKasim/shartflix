import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? svgIconPath;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.svgIconPath,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
        prefixIcon: svgIconPath != null
            ? Padding(
                padding: const EdgeInsets.all(7.0)
                    .add(const EdgeInsets.only(left: 14)),
                child: SvgPicture.asset(
                  svgIconPath!,
                  width: 17,
                  height: 17,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(10.0)
                    .add(const EdgeInsets.only(right: 24)),
                child: suffixIcon,
              )
            : null,
        filled: true,
        fillColor: AppTheme.transparent10White,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppBorderRadius.loginTextField,
          borderSide: BorderSide(
            color: AppTheme.transparent20White,
            width: 1,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.loginTextField,
          borderSide: BorderSide(
            color: AppTheme.transparent20White,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.loginTextField,
          borderSide: BorderSide(
            color: AppTheme.primaryRed,
            width: 1,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.loginTextField,
          borderSide: BorderSide(
            color: AppTheme.errorRed,
            width: 1,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.loginTextField,
          borderSide: BorderSide(
            color: AppTheme.errorRed,
            width: 1,
          ),
        ),
      ),
    );
  }
}
