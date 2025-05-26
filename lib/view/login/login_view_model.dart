import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/domain/domain_model/user_model.dart';
import 'package:mental_care_chat_demo/domain/repository/auth_repository.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/login/login_state.dart';

class LoginViewModel extends Notifier<LoginState> {
  late final AuthRepository _authRepository;

  @override
  LoginState build() {
    _authRepository = ref.read(authRepositoryProvider);
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

  Future<bool> isLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (state.isEmailValidation && state.isPasswordValidation) {
      state = state.copyWith(isLoading: true);
      final UserModel? user = await _authRepository.loginWithEmail(
        email: email,
        password: password,
      );
      print("UserModel $user");
      if (user != null) {
        ref.read(appViewModelProvider.notifier).setLoginUser(user: user);
        state = state.copyWith(isLoading: false);
        if (user.lastCesdDate != null) {
          context.go('/report');
        } else {
          context.go('/home-empty');
        }
      }
    } else {
      Fluttertoast.showToast(msg: '먼저 올바른 형식의 아이디와 비밀번호를 입력해주세요');
    }

    return false;
  }
}
