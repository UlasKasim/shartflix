import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';

import '../../../core/theme/app_theme.dart';
import 'social_login_section.dart';

class AuthBaseWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget formContent;
  final VoidCallback onMainButtonPressed;
  final String mainButtonText;
  final bool isLoading;
  final String bottomText;
  final String bottomActionText;
  final VoidCallback onBottomActionPressed;
  final Widget? extraContent; // For terms and conditions in register

  const AuthBaseWidget({
    super.key,
    required this.title,
    required this.description,
    required this.formContent,
    required this.onMainButtonPressed,
    required this.mainButtonText,
    required this.isLoading,
    required this.bottomText,
    required this.bottomActionText,
    required this.onBottomActionPressed,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Screen size based responsive values
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(
                left: isSmallScreen ? 24.0 : 39.0,
                right: isSmallScreen ? 24.0 : 39.0,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Top spacer - responsive
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: (isSmallScreen ? 20 : 60),
                      ),

                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                      ),

                      SizedBox(height: isSmallScreen ? 6 : 8),

                      // Description
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontSize: isSmallScreen ? 12 : 13,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                      ),

                      // Spacing - responsive
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: (isSmallScreen ? 32 : 45),
                      ),

                      // Form Content (TextFields)
                      formContent,

                      // Extra content (terms)
                      if (extraContent != null) ...[
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        extraContent!,
                      ],

                      SizedBox(
                        height: extraContent != null
                            ? (isSmallScreen ? 24 : 38)
                            : (isSmallScreen ? 16 : 20),
                      ),

                      // Main Button
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 48 : 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : onMainButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: AppTheme.textPrimary,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppBorderRadius.loginButton,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: isSmallScreen ? 18 : 20,
                                  height: isSmallScreen ? 18 : 20,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.textPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  mainButtonText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontSize: isSmallScreen ? 14 : 15,
                                        fontWeight: FontWeight.w500,
                                        height: 1.0,
                                      ),
                                ),
                        ),
                      ),

                      // Social login spacing - responsive ve dengeli
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isSmallScreen ? 24 : 32,
                      ),

                      // Social Login Buttons - keyboard'da gizle
                      BlocProvider(
                        create: (_) => SocialLoginCubit(),
                        child: const SocialLoginSection(),
                      ),

                      // Bottom spacing - responsive ve dengeli
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isSmallScreen ? 32 : 40,
                      ),

                      // Bottom Action Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              bottomText,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppTheme.transparent50White,
                                    fontSize: isSmallScreen ? 11 : 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onBottomActionPressed,
                            child: Text(
                              bottomActionText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontSize: isSmallScreen ? 11 : 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
