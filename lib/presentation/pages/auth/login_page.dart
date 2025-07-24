import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:shartflix/core/core.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/routes/routes.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _onRegisterPressed() {
    context.goNamed(RouteNames.register);
  }

  void _onForgotPasswordPressed() {
    sl<NavigationService>().showSnackBar(
      context.l10n.notImplementedYet,
      type: SnackBarType.info,
    );
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
                title: context.l10n.loginTitle,
                description: context.l10n.loginDescription,
                formContent: _buildFormContent(context),
                onMainButtonPressed: _onLoginPressed,
                mainButtonText: context.l10n.login,
                isLoading: authState is AuthLoading,
                bottomText: context.l10n.dontHaveAccount,
                bottomActionText: context.l10n.register,
                onBottomActionPressed: _onRegisterPressed,
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

          // Password TextField with BlocBuilder for visibility
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

          const SizedBox(height: 28),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _onForgotPasswordPressed,
              child: Text(
                context.l10n.forgotPassword,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.textPrimary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
