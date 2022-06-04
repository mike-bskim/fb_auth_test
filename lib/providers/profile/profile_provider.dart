import 'package:fb_auth_test/repositories/profile_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import 'profile_state.dart';

//profileRepo 가 필요하므로 LocatorMixin 추가해야 함.
class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  // ProfileState _state = ProfileState.init();
  // ProfileState get state => _state;
  ProfileProvider(super.state);

  // final ProfileRepo profileRepo;
  // ProfileProvider({required this.profileRepo});

  Future<void> getProfile({
    required String uid,
  }) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    // notifyListeners();

    try {
      final User user = await read<ProfileRepo>().getProfile(uid: uid);
      debugPrint('user inform: $user');
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      // notifyListeners();
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      // notifyListeners();
    }
  }
}
