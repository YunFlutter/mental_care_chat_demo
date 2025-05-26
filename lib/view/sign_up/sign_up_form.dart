import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:validator_regex/validator_regex.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDayController = TextEditingController();
  DateTime _selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);
    final viewModel = ref.read(signUpViewModelProvider.notifier);

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
              TextFormField(
                readOnly: true,
                controller: _birthDayController,
                decoration: InputDecoration(
                  icon: Icon(Icons.cake),
                  labelText: '생년월일',
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 15, right: 15),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: const Text(
                                  "선택완료",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ScrollDateTimePicker(
                                itemExtent: 40,
                                style: DateTimePickerStyle(
                                  activeDecoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0x66CCCCCC),
                                    ),
                                  ),
                                ),
                                infiniteScroll: false,
                                dateOption: DateTimePickerOption(
                                  initialDate: _selectDate,
                                  dateFormat: DateFormat('yyyyMMdd'),
                                  minDate: DateTime(1900, 1),
                                  maxDate: DateTime.now(),
                                ),
                                onChange: (DateTime datetime) {
                                  _selectDate = datetime;
                                  _birthDayController.text =
                                      '${datetime.year}년 ${datetime.month}월 ${datetime.day}일';
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (!state.isPasswordValidation) {
              Fluttertoast.showToast(msg: '비밀번호는 영문과 숫자의 혼합으로 만들어져야 합니다');
              return;
            }
            if (!state.isEmailValidation) {
              Fluttertoast.showToast(msg: '올바른 이메일 형식을 입력해주세요');
              return;
            }

            if (_birthDayController.text == '') {
              Fluttertoast.showToast(msg: '생년 월일을 입력해주세요');
              return;
            }

            await viewModel.register(
              email: _emailController.text,
              password: _passwordController.text,
              birthDate: _birthDayController.text,
              birthDateTime: _selectDate,
            );
          },
          child: const Text('회원가입'),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("이미 계정이 있으신가요? "),
            GestureDetector(
              onTap: () {
                context.go('/login');
              },
              child: const Text("로그인", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ],
    );
  }
}
