import 'package:demo1/features/auth/data/models/app_user.dart';
import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:demo1/features/auth/presentation/viewmodels/session_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubRepository implements AuthRepository {
  _StubRepository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<AppUser> signIn({
    required String identifier,
    required String password,
  }) async {
    if (shouldFail) throw InvalidCredentialsException();
    return const AppUser(displayName: 'Test');
  }
}

void main() {
  late SessionViewModel session;

  setUp(() {
    session = SessionViewModel();
  });

  test('empty identifier gives emptyIdentifier error', () async {
    final vm = LoginViewModel(_StubRepository(), session);

    final ok = await vm.signIn(identifier: '  ', password: '123456');

    expect(ok, false);
    expect(vm.error, LoginError.emptyIdentifier);
  });

  test('short password gives passwordTooShort error', () async {
    final vm = LoginViewModel(_StubRepository(), session);

    final ok = await vm.signIn(identifier: 'farmer', password: '123');

    expect(ok, false);
    expect(vm.error, LoginError.passwordTooShort);
  });

  test('successful sign in logs the user into the session', () async {
    final vm = LoginViewModel(_StubRepository(), session);

    final ok = await vm.signIn(identifier: 'farmer', password: '123456');

    expect(ok, true);
    expect(vm.error, isNull);
    expect(vm.isLoading, false);
    expect(session.isLoggedIn, true);
    expect(session.user?.displayName, 'Test');
  });

  test('repository failure gives invalidCredentials and no session', () async {
    final vm = LoginViewModel(_StubRepository(shouldFail: true), session);

    final ok = await vm.signIn(identifier: 'farmer', password: '123456');

    expect(ok, false);
    expect(vm.error, LoginError.invalidCredentials);
    expect(vm.isLoading, false);
    expect(session.isLoggedIn, false);
  });
}
