import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_care_chat_demo/domain/repository/emotion_repository.dart';
import 'package:mental_care_chat_demo/view/emotion_report/emotion_report_state.dart';
import 'dart:developer' as dev;


class EmotionRepositoryImpl implements EmotionRepository {
  final FirebaseFirestore _firestore;

  EmotionRepositoryImpl(this._firestore);

  @override
  Future<EmotionReportState> fetchLatestEmotionReport(String uid) async {
    final collectionRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('cesd_results');

    final snapshot = await collectionRef
        .orderBy('submittedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception("감정 리포트가 존재하지 않습니다.");
    }

    final aiDataString = snapshot.docs.first.data()['aiAnalysis'].toString().replaceAll('```', "").replaceAll('json', '');
    print(aiDataString.runtimeType);
    final data = jsonDecode(aiDataString);
    print(data.runtimeType);

    return EmotionReportState(
      emotionScores: Map<String, double>.from(
        (data['emotion_scores'] as Map).map(
              (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
        ),
      ),
      statusSummary: data['status_summary'] ?? '',
      advice: data['advice'] ?? '',
      recommendedActivities: List<String>.from(data['recommended_activities'] ?? []),
    );
  }
}