import 'package:demo1/features/auth/data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password != '123456') throw InvalidCredentialsException();
  }
}
