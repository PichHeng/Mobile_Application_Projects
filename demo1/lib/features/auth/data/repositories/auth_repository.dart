class InvalidCredentialsException implements Exception {}

abstract class AuthRepository {
  Future<void> signIn({required String identifier, required String password});
}
