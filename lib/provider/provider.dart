import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/common/app_state/app_state.dart';
import 'package:mental_care_chat_demo/common/app_state/app_view_model.dart';
import 'package:mental_care_chat_demo/data/repository_impl/auth_repository_impl.dart';
import 'package:mental_care_chat_demo/domain/repository/auth_repository.dart';
import 'package:mental_care_chat_demo/view/login/login_state.dart';
import 'package:mental_care_chat_demo/view/login/login_view_model.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_state.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_view_model.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  () => LoginViewModel(),
);

final signUpViewModelProvider = NotifierProvider<SignUpViewModel, SignUpState>(
  () => SignUpViewModel(),
);

final appViewModelProvider = NotifierProvider<AppViewModel, AppState>(
  () => AppViewModel(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance);
});
