import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';

class CesdScreen extends ConsumerWidget {
  const CesdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cesdProvider);
    final viewModel = ref.read(cesdProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('CES-D 우울증 자가진단'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: state.questions.length + 1,
        itemBuilder: (context, index) {
          // 마지막 제출 버튼
          if (index == state.questions.length) {
            final isComplete = !state.answers.contains(null);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton(
                onPressed:
                    isComplete
                        ? () async {
                          final score = viewModel.totalScore;
                          final result = await viewModel.saveCesdResult();

                          if (result != null) {
                            viewModel.showAnalyzingDialog(context);
                            final aiData = await viewModel.getAiAnalysis();
                            if (aiData == null) {
                              Fluttertoast.showToast(
                                msg: '❌ ai 분석에 실패했습니다. 초기 페이지로 돌아 갑니다',
                              );
                              context.pop();
                              context.go('/home');

                              return;
                            }

                            final saveAiData = await viewModel.updateAiData(
                              resultId: result,
                              aiAnalysis: aiData,
                            );

                            if (!saveAiData) {
                              Fluttertoast.showToast(
                                msg: '❌ ai 분석 결과 저장에 실패했습니다. 초기 페이지로 돌아 갑니다',
                              );
                              context.pop();
                              context.go('/home');

                              return;
                            }

                            Future.delayed(Duration(milliseconds: 500), () {
                              context.pop();
                              context.go('/report');
                            });
                          } else {
                            context.go('/home');
                            Fluttertoast.showToast(
                              msg: '❌ 검사결과 저장에 실패했습니다. 초기 페이지로 돌아 갑니다',
                            );
                          }
                        }
                        : null,
                child: const Text('제출하기'),
              ),
            );
          }

          // 설문 문항
          final question = state.questions[index];
          final selected = state.answers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. $question',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(state.options.length, (i) {
                    return RadioListTile<int>(
                      value: i,
                      groupValue: selected,
                      onChanged: (value) {
                        viewModel.updateAnswer(index, value!);
                      },
                      title: Text(state.options[i]),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
