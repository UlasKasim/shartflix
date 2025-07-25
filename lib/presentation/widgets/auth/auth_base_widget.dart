import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/widgets/common/common.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
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
    final r = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: r.contentWrapper(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: r.screenHeight -
                          MediaQuery.of(context).padding.top -
                          32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Top spacer - responsive
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: r.isSmallScreen ? 20 : 60,
                        ),

                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontSize: r.titleFontSize,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                        ),

                        SizedBox(height: r.isSmallScreen ? 6 : 8),

                        // Description
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontSize: r.subtitleFontSize,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                        ),

                        // Spacing - responsive
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: r.isSmallScreen ? 32 : 45,
                        ),

                        // Form Content (TextFields)
                        formContent,

                        // Extra content (terms)
                        if (extraContent != null) ...[
                          SizedBox(height: r.mediumSpacing),
                          extraContent!,
                        ],

                        SizedBox(
                          height: extraContent != null
                              ? r.largeSpacing
                              : r.mediumSpacing,
                        ),

                        // Main Button
                        PrimaryButton.auth(
                          text: mainButtonText,
                          onPressed: onMainButtonPressed,
                          isLoading: isLoading,
                        ),

                        // Social login spacing - responsive
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: r.largeSpacing,
                        ),

                        // Social Login Buttons
                        BlocProvider(
                          create: (_) => SocialLoginCubit(),
                          child: const SocialLoginSection(),
                        ),

                        // Bottom spacing - responsive
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: r.largeSpacing,
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
                                      fontSize: r.captionFontSize,
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
                                      fontSize: r.captionFontSize,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // Final bottom padding
                        SizedBox(height: r.largeSpacing),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
