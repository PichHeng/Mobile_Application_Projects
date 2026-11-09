import 'package:demo1/features/auth/data/models/app_user.dart';

class InvalidCredentialsException implements Exception {}

abstract class AuthRepository {
  Future<AppUser> signIn({
    required String identifier,
    required String password,
  });
}
