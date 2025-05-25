import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  final bool isPasswordVisible;
  final bool isEmailValidation;
  final bool isPasswordValidation;

  const LoginState({
    this.isPasswordVisible = false,
    this.isEmailValidation = false,
    this.isPasswordValidation = false,
  });
}
