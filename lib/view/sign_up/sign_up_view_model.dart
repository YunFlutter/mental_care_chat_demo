import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/domain/repository/auth_repository.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_state.dart';

class SignUpViewModel extends Notifier<SignUpState> {
  late final AuthRepository _authRepository;

  @override
  SignUpState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const SignUpState();
  }

  void isEmailValidation({required bool validation}) {
    state = state.copyWith(isEmailValidation: validation);
  }

  void isPassWordValidation({required bool validation}) {
    state = state.copyWith(isPasswordValidation: validation);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> register({
    required String email,
    required String password,
    required String birthDate,
    required DateTime birthDateTime, // DateTime 파라미터 추가
  }) async {
    state = state.copyWith(isLoading: true);

    // 한국식 만나이 계산
    final now = DateTime.now();
    int age = now.year - birthDateTime.year;
    if (now.month < birthDateTime.month ||
        (now.month == birthDateTime.month && now.day < birthDateTime.day)) {
      age--;
    }

    final result = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      birthDate: birthDate,
      age: age,
    );

    state = state.copyWith(isLoading: false);
  }
}
