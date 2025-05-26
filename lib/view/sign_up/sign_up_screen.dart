import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_form.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_view_model.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_state.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '환영합니다!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '회원가입을 진행해주세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 32),
                  SignUpForm(),
                ],
              ),
            ),
          ),
        ),

        // 로딩 상태일 때 로딩 오버레이 표시
        if (signUpState.isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}