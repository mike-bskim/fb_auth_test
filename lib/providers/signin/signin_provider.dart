import 'package:fb_auth_test/models/custom_error.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

import '../../repositories/auth_repo.dart';
import 'signin_state.dart';

class SignInProvider extends ChangeNotifier {
  SignInState _state = SignInState.init();

  SignInState get state => _state;

  final AuthRepo authRepo;

  SignInProvider({
    required this.authRepo,
  });

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _state = _state.copyWith(signInStatus: SignInStatus.submitting);
    notifyListeners();

    try {
      await authRepo.signIn(email: email, password: password);
      _state = _state.copyWith(signInStatus: SignInStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signInStatus: SignInStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
