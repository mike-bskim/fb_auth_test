// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/auth_repo.dart';
import 'auth_state.dart';

//authRepo 가 필요하므로 LocatorMixin 추가해야 함.
class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  // AuthState _state = AuthState.unknown();
  // AuthState get state => _state;
  // AuthProvider() : super(AuthState.unknown()); // 3.0 이전방식
  AuthProvider(super.state); // 3.0 방식.

  // with LcatiorMixin 으로 제거가능
  // final AuthRepo authRepo;
  // AuthProvider({required this.authRepo});

  // 이건 아래처럼 변경해야 함.
  // void update(fb_auth.User? user) {
  //   if (user != null) {
  //     _state = _state.copyWith(
  //       authStatus: AuthStatus.authenticated,
  //       user: user,
  //     );
  //   } else {
  //     _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
  //   }
  //   // debugPrint('*** auth_provider >> update >> authState: $_state');
  //   notifyListeners();
  // }

  @override
  void update(Locator watch) {
    final user = watch<fb_auth.User?>();

    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    debugPrint('*** auth_provider >> update >> authState: $state');
    // notifyListeners(); // state 방식에서는 필요없음.
    super.update(watch);
  }

  void signOut() async {
    // await authRepo.signOut();
    await read<AuthRepo>().signOut();
  }
}
