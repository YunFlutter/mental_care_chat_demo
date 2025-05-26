import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_care_chat_demo/domain/repository/cesd_repository.dart';


class CesdRepositoryImpl implements CesdRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CesdRepositoryImpl(this._firestore, this._auth);

  @override
  Future<void> updateCesdResult({required int score}) async {
    final user = _auth.currentUser;

    if (user == null) throw Exception('로그인된 유저가 없습니다.');

    await _firestore.collection('users').doc(user.uid).update({
      'lastCesdScore': score,
      'lastCesdDate': FieldValue.serverTimestamp(),
    });
  }
}