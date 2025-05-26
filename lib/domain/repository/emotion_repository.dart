import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_state.dart';

abstract class EmotionRepository {
  Future<EmotionReportState> fetchLatestEmotionReport(String uid);
}