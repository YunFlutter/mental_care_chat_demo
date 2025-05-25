abstract interface class AuthRepository {
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String birthDate,
  });
}