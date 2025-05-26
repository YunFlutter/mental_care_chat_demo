import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';
import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_state.dart';

class EmotionReportScreen extends ConsumerWidget {
  const EmotionReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(emotionReportProvider);
    final asyncViewmodel = ref.watch(emotionReportProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('감정 리포트')),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    '🚨 오류가 발생했습니다\n${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await asyncViewmodel.reloadState();
                  },
                  child: Text("재시도 하기"),
                ),
              ],
            ),
        data: (state) => _EmotionReportContent(state: state),
      ),
    );
  }
}

class _EmotionReportContent extends StatelessWidget {
  final EmotionReportState state;

  const _EmotionReportContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final scores = state.emotionScores;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            '📝 감정 상태 요약',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(state.statusSummary, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          const Text(
            '📊 감정 점수 그래프',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 200, child: EmotionBarChart(scores: scores)),
          const SizedBox(height: 24),
          const Text(
            '💡 조언',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(state.advice, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          const Text(
            '✨ 추천 활동',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...state.recommendedActivities.map(
            (activity) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(activity, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class EmotionBarChart extends StatelessWidget {
  final Map<String, double> scores;

  const EmotionBarChart({super.key, required this.scores});

  static const Map<String, String> _koreanLabels = {
    'sadness': '슬픔 😢',
    'anxiety': '불안 😰',
    'helplessness': '무기력 😔',
    'loneliness': '외로움 🥺',
    'hope': '희망 🌱',
  };

  @override
  Widget build(BuildContext context) {
    final englishKeys = scores.keys.toList();
    final koreanLabels = englishKeys.map((e) => _koreanLabels[e] ?? e).toList();
    final values = scores.values.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < koreanLabels.length) {
                  return Text(
                    koreanLabels[index],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: values
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        )
            .toList(),
      ),
    );
  }
}
