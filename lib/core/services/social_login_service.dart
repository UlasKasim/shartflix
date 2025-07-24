import 'package:shartflix/core/extensions/localization_extension.dart';
import 'package:shartflix/core/injection/injection.dart';
import 'package:shartflix/core/services/services.dart';

enum SocialLoginType { google, apple, facebook }

class SocialLoginService {
  static final SocialLoginService _instance = SocialLoginService._internal();
  factory SocialLoginService() => _instance;
  SocialLoginService._internal();

  final _logger = sl<LoggerService>();
  final _navigationService = sl<NavigationService>();

  Future<void> loginWithGoogle() async {
    try {
      _logger.userAction('Google Login Attempted');

      _navigationService.showSnackBar(
        _navigationService.context!.l10n.notImplementedYet,
        type: SnackBarType.info,
      );

      _logger.i('🔍 Google login initiated');
    } catch (e, stackTrace) {
      _logger.e('Google login failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> loginWithApple() async {
    try {
      _logger.userAction('Apple Login Attempted');

      _navigationService.showSnackBar(
        _navigationService.context!.l10n.notImplementedYet,
        type: SnackBarType.info,
      );

      _logger.i('🍎 Apple login initiated');
    } catch (e, stackTrace) {
      _logger.e('Apple login failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      _logger.userAction('Facebook Login Attempted');

      _navigationService.showSnackBar(
        _navigationService.context!.l10n.notImplementedYet,
        type: SnackBarType.info,
      );

      _logger.i('👥 Facebook login initiated');
    } catch (e, stackTrace) {
      _logger.e('Facebook login failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> registerWithGoogle() async {
    // Same implementation as login - Firebase handles this automatically
    return await loginWithGoogle();
  }

  Future<void> registerWithApple() async {
    // Same implementation as login - Firebase handles this automatically
    return await loginWithApple();
  }

  Future<void> registerWithFacebook() async {
    // Same implementation as login - Firebase handles this automatically
    return await loginWithFacebook();
  }

  Future<void> handleSocialLogin(SocialLoginType type) async {
    switch (type) {
      case SocialLoginType.google:
        await loginWithGoogle();
        break;
      case SocialLoginType.apple:
        await loginWithApple();
        break;
      case SocialLoginType.facebook:
        await loginWithFacebook();
        break;
    }
  }
}
