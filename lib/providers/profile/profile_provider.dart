import 'package:fb_auth_test/repositories/profile_repo.dart';
import 'package:flutter/foundation.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import 'profile_state.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileState _state = ProfileState.init();

  ProfileState get state => _state;

  final ProfileRepo profileRepo;

  ProfileProvider({
    required this.profileRepo,
  });

  Future<void> getProfile({
    required String uid,
  }) async {
    _state = _state.copyWith(profileStatus: ProfileStatus.loading);
    notifyListeners();

    try {
      final User user = await profileRepo.getProfile(uid: uid);
      debugPrint('user inform: $user');
      _state = _state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(profileStatus: ProfileStatus.error, error: e);
      notifyListeners();
    }
  }
}
