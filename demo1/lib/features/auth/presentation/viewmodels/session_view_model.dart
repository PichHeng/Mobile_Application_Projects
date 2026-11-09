import 'package:demo1/features/auth/data/models/app_user.dart';
import 'package:flutter/foundation.dart';

class SessionViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
