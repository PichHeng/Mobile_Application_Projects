import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubRepository implements AuthRepository {
  _StubRepository() : shouldFail = false;

  final bool shouldFail;

  @override
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    if (shouldFail) throw InvalidCredentialsException();
  }
}

void main() {
  test('short password gives passwordTooShort error', () async {
    final vm = LoginViewModel(_StubRepository());

    final ok = await vm.signIn(identifier: 'sok', password: '123');

    expect(ok, false);
    expect(vm.error, LoginError.passwordTooShort);
  });
}
