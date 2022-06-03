import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';

// import 'package:fb_auth_test/models/custom_error.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final User user;
  final CustomError error;
  const ProfileState({
    required this.profileStatus,
    required this.user,
    required this.error,
  });

  factory ProfileState.init() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      user: User.init(),
      error: const CustomError(),
    );
  }

  @override
  List<Object> get props => [profileStatus, user, error];

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, user: $user, error: $error)';

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    User? user,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
