import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/cesd/cesd_state.dart';



class CesdViewModel extends Notifier<CesdState> {
  @override
  CesdState build() {
    return CesdState.initial();
  }

  void updateAnswer(int index, int score) {
    final updatedAnswers = [...state.answers];
    updatedAnswers[index] = score;
    state = state.copyWith(answers: updatedAnswers);
  }

  int get totalScore {
    int score = 0;
    for (int i = 0; i < state.answers.length; i++) {
      final answer = state.answers[i];
      if (answer != null) {
        if ([4, 9, 14].contains(i)) {
          score += 3 - answer;
        } else {
          score += answer;
        }
      }
    }
    return score;
  }
  Future<void> saveCesdResult() async {
    final repo = ref.read(cesdRepositoryProvider);
    await repo.updateCesdResult(score: totalScore);
  }
}