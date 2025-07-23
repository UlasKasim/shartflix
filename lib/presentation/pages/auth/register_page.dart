import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/constants/constants.dart';

import '../../../core/extensions/localization_extension.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/injection/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/password_visibility_cubit.dart';
import '../../routes/app_router.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_base_widget.dart';
import '../../widgets/common/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: _emailController.text.trim(),
              name: _nameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _onLoginPressed() {
    context.goNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(RouteNames.home);
          } else if (state is AuthError) {
            sl<NavigationService>().showSnackBar(
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, authState) {
          return LoadingOverlay(
            isLoading: authState is AuthLoading,
            child: BlocProvider(
              create: (_) => PasswordVisibilityCubit(),
              child: AuthBaseWidget(
                title: context.l10n.registerTitle,
                description: context.l10n.registerDescription,
                formContent: _buildFormContent(context),
                onMainButtonPressed: _onRegisterPressed,
                mainButtonText: context.l10n.registerNow,
                isLoading: authState is AuthLoading,
                bottomText: context.l10n.alreadyHaveAccount,
                bottomActionText: context.l10n.loginNow,
                onBottomActionPressed: _onLoginPressed,
                extraContent: _buildTermsAndConditions(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name TextField
          AuthTextField(
            controller: _nameController,
            hintText: context.l10n.name,
            svgIconPath: AssetConstants.iconUser,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return context.l10n.nameRequired;
              }
              if (!ValidationHelper.isValidName(value)) {
                return context.l10n.errorValidationName;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Email TextField
          AuthTextField(
            controller: _emailController,
            hintText: context.l10n.email,
            svgIconPath: AssetConstants.iconEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return context.l10n.emailRequired;
              }
              if (!ValidationHelper.isValidEmail(value)) {
                return context.l10n.errorValidationEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password TextField with BlocBuilder
          BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
            builder: (context, visibilityState) {
              return AuthTextField(
                controller: _passwordController,
                hintText: context.l10n.password,
                svgIconPath: AssetConstants.iconLock,
                obscureText: !visibilityState.isPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () {
                    context
                        .read<PasswordVisibilityCubit>()
                        .togglePasswordVisibility();
                  },
                  child: SvgPicture.asset(
                    visibilityState.isPasswordVisible
                        ? AssetConstants.iconEyeOpen
                        : AssetConstants.iconEyeClosed,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return context.l10n.passwordRequired;
                  }
                  if (value!.length < ValidationConstants.minPasswordLength) {
                    return context.l10n.errorValidationPassword;
                  }
                  return null;
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password TextField with BlocBuilder
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: context.l10n.confirmPassword,
            svgIconPath: AssetConstants.iconLock,
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return context.l10n.confirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return context.l10n.errorValidationPasswordMatch;
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return GestureDetector(
      onTap: _onTermsPressed,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.transparent50White,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
          children: [
            TextSpan(
              text: context.l10n.termsPrefix,
            ),
            TextSpan(
              text: context.l10n.termsLinkText,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.textPrimary,
                color: AppTheme.textPrimary,
              ),
            ),
            TextSpan(
              text: context.l10n.termsSuffix,
            ),
          ],
        ),
      ),
    );
  }

  void _onTermsPressed() {
    sl<NavigationService>().showSnackBar(
      context.l10n.notImplementedYet,
      type: SnackBarType.info,
    );
  }
}
