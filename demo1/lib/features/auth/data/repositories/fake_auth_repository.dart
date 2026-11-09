import 'package:demo1/features/auth/data/models/app_user.dart';
import 'package:demo1/features/auth/data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AppUser> signIn({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (identifier.trim().toLowerCase() != 'farmer' || password != '123456') {
      throw InvalidCredentialsException();
    }
    return const AppUser(displayName: 'Farmer');
  }
}
