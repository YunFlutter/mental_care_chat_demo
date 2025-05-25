import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:validator_regex/validator_regex.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Column(
      children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _emailController,
                onChanged: (value) {
                  final isValid = Validator.email(value);
                  viewModel.isEmailValidation(validation: isValid);
                },
                validator: (String? value) {
                  if (!Validator.email(value!)) {
                    return '이메일 형식이 일치하지 않습니다';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: '이메일',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  final isValid =
                      value.length > 5 && Validator.alphanumeric(value);
                  viewModel.isPassWordValidation(validation: isValid);
                },
                validator: (String? value) {
                  if (value!.length <= 5 || !Validator.alphanumeric(value)) {
                    return '올바른 비밀번호가 아닙니다';
                  }
                  return null;
                },
                obscureText: !state.isPasswordVisible,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: '비밀번호',
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: viewModel.togglePasswordVisibility,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {
          viewModel.isLogin(
            email: _emailController.text,
            password: _passwordController.text,
          );
        }, child: const Text('로그인')),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("처음 오셨나요? "),
            GestureDetector(
              onTap: () {
                context.go('/sign-up');
              },
              child: const Text("회원가입", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ],
    );
  }
}
