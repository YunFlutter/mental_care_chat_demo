import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/common/app_state/app_state.dart';
import 'package:mental_care_chat_demo/common/app_state/app_view_model.dart';
import 'package:mental_care_chat_demo/data/repository_impl/auth_repository_impl.dart';
import 'package:mental_care_chat_demo/data/repository_impl/cesd_repository_impl.dart';
import 'package:mental_care_chat_demo/data/repository_impl/emotion_repository_impl.dart';
import 'package:mental_care_chat_demo/data/repository_impl/openai_repository_impl.dart';
import 'package:mental_care_chat_demo/domain/repository/auth_repository.dart';
import 'package:mental_care_chat_demo/domain/repository/cesd_repository.dart';
import 'package:mental_care_chat_demo/domain/repository/emotion_repository.dart';
import 'package:mental_care_chat_demo/domain/repository/openai_repository.dart';
import 'package:mental_care_chat_demo/view/cesd/cesd_state.dart';
import 'package:mental_care_chat_demo/view/cesd/cesd_view_model.dart';
import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_state.dart';
import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_view_model.dart';
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

final cesdProvider = NotifierProvider<CesdViewModel, CesdState>(
  () => CesdViewModel(),
);

final emotionRepositoryProvider = Provider<EmotionRepository>(
      (ref) => EmotionRepositoryImpl(FirebaseFirestore.instance),
);

final emotionReportProvider =
AsyncNotifierProvider<EmotionReportViewModel, EmotionReportState>(
      () => EmotionReportViewModel(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance);
});



final openAiRepositoryProvider = Provider<OpenAiRepository>((ref) {
  return OpenAiRepositoryImpl();
});

final cesdRepositoryProvider = Provider<CesdRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return CesdRepositoryImpl(firestore, ref);
});
