import 'package:fb_auth_test/models/custom_error.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/auth_repo.dart';
import 'signup_state.dart';

class SignUpProvider extends ChangeNotifier {
  SignUpState _state = SignUpState.init();

  SignUpState get state => _state;

  final AuthRepo authRepo;

  SignUpProvider({
    required this.authRepo,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _state = _state.copyWith(signUpStatus: SignUpStatus.submitting);
    notifyListeners();

    try {
      await authRepo.signUp(name: name, email: email, password: password);
      _state = _state.copyWith(signUpStatus: SignUpStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signUpStatus: SignUpStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
