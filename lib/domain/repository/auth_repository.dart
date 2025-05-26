import 'package:mental_care_chat_demo/domain/domain_model/user_model.dart';

abstract interface class AuthRepository {
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String birthDate,
    required int age,
  });
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  });
}
