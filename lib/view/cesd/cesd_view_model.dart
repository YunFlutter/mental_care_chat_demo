import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/cesd/cesd_state.dart';

class CesdViewModel extends Notifier<CesdState> {
  @override
  CesdState build() => CesdState.initial();

  /// 문항 응답 업데이트
  void updateAnswer(int index, int score) {
    if (index < 0 || index >= state.answers.length) return;

    final updatedAnswers = [...state.answers]..[index] = score;
    state = state.copyWith(answers: updatedAnswers);
  }

  /// 총 점수 계산 (역채점 포함)
  int get totalScore {
    return List.generate(state.answers.length, (i) {
      final answer = state.answers[i];
      if (answer == null) return 0;

      return [4, 9, 14].contains(i) ? 3 - answer : answer;
    }).reduce((a, b) => a + b);
  }

  /// Firestore에 검사 결과 저장
  Future<String?> saveCesdResult() async {
    final repo = ref.read(cesdRepositoryProvider);
    final completedAnswers = state.answers;

    if (completedAnswers.contains(null)) {
      throw Exception('모든 문항에 응답해야 저장할 수 있습니다.');
    }

    return await repo.saveCesdResultOnly(
      score: totalScore,
      answers: completedAnswers.cast<int>(),
    );
  }

  Future<bool> updateAiData({
    required String resultId,
    required String aiAnalysis,
  }) async {
    final repo = ref.read(cesdRepositoryProvider);
    final result = await repo.updateAiAnalysis(
      resultId: resultId,
      aiAnalysis: aiAnalysis,
    );
    return result;
  }

  /// ✅ GPT 기반 AI 분석 결과 호출
  Future<String?> getAiAnalysis() async {
    final repo = ref.read(openAiRepositoryProvider);
    final userRepo = ref.read(appViewModelProvider);

    // null 체크
    if (state.answers.contains(null)) {
      return '모든 문항에 응답해주세요.';
    }

    try {
      final result = await repo.analyzeCesdResult(
        questions: state.questions,
        answers: state.answers.cast<int>(),
        options: state.options,
        age: userRepo.user!.age,
      );

      return result; // 화면이나 상태에 저장 가능
    } catch (e) {
      print('❌ GPT 분석 오류: $e');
      return 'AI 분석 중 오류가 발생했습니다.';
    }
  }

  void showAnalyzingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("AI 분석을 진행 중이에요...", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  "잠시만 기다려주세요 😊",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
