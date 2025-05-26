import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_care_chat_demo/common/app_state/app_state.dart';
import 'package:mental_care_chat_demo/common/app_state/app_view_model.dart';
import 'package:mental_care_chat_demo/domain/repository/emotion_repository.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_state.dart';


class EmotionReportViewModel extends AsyncNotifier<EmotionReportState> {
  late final EmotionRepository _repository;
  late final AppState _userState;

  @override
  Future<EmotionReportState> build() async {
    _repository = ref.read(emotionRepositoryProvider);
    _userState = ref.read(appViewModelProvider);
    final uid = _userState.user!.uid;

    return await _repository.fetchLatestEmotionReport(uid);
  }

  Future<void> reloadState() async {
    final uid = _userState.user!.uid;
    final result = await _repository.fetchLatestEmotionReport(uid); // 예시
    state = AsyncData(result);
  }
}

