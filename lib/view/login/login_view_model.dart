import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/view/login/login_state.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(() => LoginViewModel());

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState(); // 초기 상태
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void isEmailValidation({required bool validation}) {
    state = state.copyWith(isEmailValidation: validation);
  }

  void isPassWordValidation({required bool validation}) {
    state = state.copyWith(isPasswordValidation: validation);
  }

  void isLogin({required String email, required String password}) {
    if(state.isEmailValidation && state.isPasswordValidation) {

    }
  }
}
