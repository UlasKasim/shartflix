import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordVisibilityState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const PasswordVisibilityState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  PasswordVisibilityState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return PasswordVisibilityState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit() : super(const PasswordVisibilityState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  void reset() {
    emit(const PasswordVisibilityState());
  }
}
