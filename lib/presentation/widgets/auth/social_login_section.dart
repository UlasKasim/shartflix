import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/constants/constants.dart';
import 'package:shartflix/core/services/social_login_service.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';

import 'social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialLoginCubit, bool>(
      builder: (context, isLoading) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              svgIconPath: AssetConstants.iconGoogle,
              onPressed: isLoading
                  ? () {}
                  : () => context
                      .read<SocialLoginCubit>()
                      .handleSocialLogin(SocialLoginType.google),
            ),
            const SizedBox(width: 8),
            SocialLoginButton(
              svgIconPath: AssetConstants.iconApple,
              onPressed: isLoading
                  ? () {}
                  : () => context
                      .read<SocialLoginCubit>()
                      .handleSocialLogin(SocialLoginType.apple),
            ),
            const SizedBox(width: 8),
            SocialLoginButton(
              svgIconPath: AssetConstants.iconFacebook,
              onPressed: isLoading
                  ? () {}
                  : () => context
                      .read<SocialLoginCubit>()
                      .handleSocialLogin(SocialLoginType.facebook),
            ),
          ],
        );
      },
    );
  }
}
