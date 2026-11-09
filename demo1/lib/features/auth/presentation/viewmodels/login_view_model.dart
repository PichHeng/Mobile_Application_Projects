import 'package:demo1/features/auth/data/repositories/auth_repository.dart';
import 'package:demo1/features/auth/presentation/viewmodels/session_view_model.dart';
import 'package:flutter/foundation.dart';

enum LoginError {
  emptyIdentifier,
  passwordTooShort,
  invalidCredentials,
  network,
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repository, this._session);

  final AuthRepository _repository;
  final SessionViewModel _session;

  bool _isLoading = false;
  bool _rememberMe = false;
  LoginError? _error;

  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  LoginError? get error => _error;

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// ត្រឡប់ true បើចូលបានជោគជ័យ
  Future<bool> signIn({
    required String identifier,
    required String password,
  }) async {
    if (identifier.trim().isEmpty) {
      _error = LoginError.emptyIdentifier;
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      _error = LoginError.passwordTooShort;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _repository.signIn(
        identifier: identifier.trim(),
        password: password,
      );
      _session.setUser(user);
      return true;
    } on InvalidCredentialsException {
      _error = LoginError.invalidCredentials;
      return false;
    } catch (_) {
      _error = LoginError.network;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
