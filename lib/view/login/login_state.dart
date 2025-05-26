// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  final bool isPasswordVisible;
  final bool isEmailValidation;
  final bool isPasswordValidation;
  final bool isLoading;

  const LoginState({
    this.isPasswordVisible = false,
    this.isEmailValidation = false,
    this.isPasswordValidation = false,
    this.isLoading = false,
  });
}
