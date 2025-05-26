import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_care_chat_demo/domain/domain_model/user_model.dart';
import 'package:mental_care_chat_demo/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String birthDate,
    required int age,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    try {
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        birthDate: birthDate,
        age: age,
        lastCesdScore: 0,
        createdAt: DateTime.now(),
        lastCesdDate: null,
      );

      print('🔥 toJson 출력: ${userModel.toJson()}');

      await _firestore.collection('users').doc(userModel.uid).set(userModel.toJson());

      print('✅ Firestore 생성 완료!');
      return null;
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");
      return e.message;
    } on FirebaseException catch (e) {
      print("❌ Firestore FirebaseException: ${e.code}, ${e.message}");
      await credential.user?.delete(); // 회원가입 실패 시 FirebaseAuth에서 삭제
      return e.message;
    } catch (e) {
      print("❌ 알 수 없는 오류: $e");
      return '알 수 없는 오류: $e';
    }
  }

  @override
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        Fluttertoast.showToast(msg: '로그인 성공!');
        return UserModel.fromJson(doc.data()!);
      } else {
        Fluttertoast.showToast(msg: '존재하지 않는 유저 입니다! 회원가입을 먼저 진행 해주세요');
        print("❌ Firestore에 해당 사용자 문서가 없음");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(msg: '존재하지 않는 유저 입니다! 회원가입을 먼저 진행 해주세요');
      }
      print("❌ FirebaseAuthException: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("❌ 로그인 중 알 수 없는 오류: $e");
      return null;
    }
  }
}
