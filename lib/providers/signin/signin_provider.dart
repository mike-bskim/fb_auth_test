import 'package:fb_auth_test/models/custom_error.dart';
// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
// import 'package:flutter/material.dart';

import '../../repositories/auth_repo.dart';
import 'signin_state.dart';

//authRepo 가 필요하므로 LocatorMixin 추가해야 함.
class SignInProvider extends StateNotifier<SignInState> with LocatorMixin {
  // SignInState _state = SignInState.init();
  // SignInState get state => _state;

  SignInProvider(super.state);

  // final AuthRepo authRepo;
  // SignInProvider({required this.authRepo});

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signInStatus: SignInStatus.submitting);
    // notifyListeners();

    try {
      await read<AuthRepo>().signIn(email: email, password: password);
      state = state.copyWith(signInStatus: SignInStatus.success);
      // notifyListeners();
    } on CustomError catch (e) {
      state = state.copyWith(signInStatus: SignInStatus.error, error: e);
      // notifyListeners();
      rethrow;
    }
  }
}
