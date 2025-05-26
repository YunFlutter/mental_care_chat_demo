import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_care_chat_demo/domain/repository/cesd_repository.dart';
import 'package:mental_care_chat_demo/provider/provider.dart';

class CesdRepositoryImpl implements CesdRepository {
  final FirebaseFirestore _firestore;
  final Ref ref;

  CesdRepositoryImpl(this._firestore, this.ref);

  @override
  Future<String?> saveCesdResultOnly({
    required int score,
    required List<int> answers,
  }) async {
    try {
      final userModel = ref.read(appViewModelProvider);
      final uid = userModel.user?.uid;
      if (uid == null) throw Exception('유저 없음');

      final now = DateTime.now();

      final resultRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('cesd_results')
          .add({
        'score': score,
        'answers': answers,
        'submittedAt': now,
        'aiAnalysis': null, // 나중에 추가할 부분
      });

      // 유저 문서에도 최신 점수 업데이트
      await _firestore.collection('users').doc(uid).update({
        'lastCesdScore': score,
        'lastCesdDate': Timestamp.fromDate(now),
      });

      return resultRef.id; // ✅ 문서 ID 반환
    } catch (e) {
      print('❌ 결과 저장 오류: $e');
      return null;
    }
  }


  Future<bool> updateAiAnalysis({
    required String resultId,
    required String aiAnalysis,
  }) async {
    try {
      final userModel = ref.read(appViewModelProvider);
      final uid = userModel.user?.uid;
      if (uid == null) throw Exception('유저 없음');

      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cesd_results')
          .doc(resultId);

      await docRef.update({'aiAnalysis': aiAnalysis});
      return true;
    } catch (e) {
      print('❌ AI 분석 업데이트 실패: $e');
      return false;
    }
  }
}
