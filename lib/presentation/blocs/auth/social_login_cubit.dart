import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/services/social_login_service.dart';

class SocialLoginCubit extends Cubit<bool> {
  SocialLoginCubit() : super(false);

  Future<void> handleSocialLogin(SocialLoginType type) async {
    emit(true);
    try {
      await SocialLoginService().handleSocialLogin(type);
    } catch (e) {
      // Handle error
    } finally {
      emit(false);
    }
  }
}
