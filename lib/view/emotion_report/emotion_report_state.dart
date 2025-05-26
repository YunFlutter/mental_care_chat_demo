import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion_report_state.freezed.dart';

@freezed
abstract class EmotionReportState with _$EmotionReportState {
  const factory EmotionReportState({
    required Map<String, double> emotionScores,
    required String statusSummary,
    required String advice,
    required List<String> recommendedActivities,
  }) = _EmotionReportState;
}