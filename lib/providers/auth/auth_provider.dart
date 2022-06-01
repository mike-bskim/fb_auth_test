import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../repositories/auth_repo.dart';
import 'auth_state.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.unknown();
  AuthState get state => _state;

  final AuthRepo authRepo;
  AuthProvider({
    required this.authRepo,
  });

  void update(fb_auth.User? user) {
    if (user != null) {
      _state = _state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    debugPrint('*** auth_provider >> update >> authState: $_state');
    notifyListeners();
  }

  void signOut() async {
    await authRepo.signOut();
  }
}
