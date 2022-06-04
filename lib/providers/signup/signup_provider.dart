import 'package:fb_auth_test/models/custom_error.dart';
// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/auth_repo.dart';
import 'signup_state.dart';

//authRepo 가 필요하므로 LocatorMixin 추가해야 함.
class SignUpProvider extends StateNotifier<SignUpState> with LocatorMixin{
  // SignUpState _state = SignUpState.init();
  // SignUpState get state => _state;
  SignUpProvider(super.state);

  // final AuthRepo authRepo;
  // SignUpProvider({required this.authRepo});

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signUpStatus: SignUpStatus.submitting);
    // notifyListeners();

    try {
      await read<AuthRepo>().signUp(name: name, email: email, password: password);
      state = state.copyWith(signUpStatus: SignUpStatus.success);
      // notifyListeners();
    } on CustomError catch (e) {
      state = state.copyWith(signUpStatus: SignUpStatus.error, error: e);
      // notifyListeners();
      rethrow;
    }
  }
}
