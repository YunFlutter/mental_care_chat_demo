// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState  {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isEmailValidation;
  final bool isPasswordValidation;

  const SignUpState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isEmailValidation = false,
    this.isPasswordValidation = false
  });
}