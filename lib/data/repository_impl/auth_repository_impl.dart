import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        birthDate: birthDate,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toJson());

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return '알 수 없는 오류가 발생했습니다.';
    }
  }
}