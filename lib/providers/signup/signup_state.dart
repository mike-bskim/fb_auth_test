import 'package:equatable/equatable.dart';

import 'package:fb_auth_test/models/custom_error.dart';

enum SignUpStatus {
  initial,
  submitting,
  success,
  error,
}

class SignUpState extends Equatable {
  final SignUpStatus signUpStatus;
  final CustomError error;
  const SignUpState({
    required this.signUpStatus,
    required this.error,
  });

  factory SignUpState.init() {
    return const SignUpState(
      signUpStatus: SignUpStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [signUpStatus, error];

  @override
  String toString() =>
      'SignUpState(singUpStatus: $signUpStatus, error: $error)';

  SignUpState copyWith({
    SignUpStatus? signUpStatus,
    CustomError? error,
  }) {
    return SignUpState(
      signUpStatus: signUpStatus ?? this.signUpStatus,
      error: error ?? this.error,
    );
  }
}
