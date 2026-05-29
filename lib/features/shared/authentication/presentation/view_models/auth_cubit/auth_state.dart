part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// role selection
class RoleSelectionChangedState extends AuthState {}

// register
class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {
  final ProfileEntity userModel;

  RegisterSuccessState(this.userModel);
}

class RegisterErrorState extends AuthState {
  final String errorMsg;

  RegisterErrorState(this.errorMsg);
}

class RegisterChangePasswordVisabilityState extends AuthState {}

// login
class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final LoginEntity userModel;

  LoginSuccessState(this.userModel);
}

class LoginErrorState extends AuthState {
  final String errorMsg;

  LoginErrorState(this.errorMsg);
}

class LoginChangeCompleteNumberStatus extends AuthState {}

//Verify Phone OTP
class VerifyPhoneOTPLoadingState extends AuthState {}

class VerifyPhoneOTPSuccessState extends AuthState {
  final ProfileEntity otpModel;

  VerifyPhoneOTPSuccessState(this.otpModel);
}

class VerifyPhoneOTPErrorState extends AuthState {
  final String errorMsg;

  VerifyPhoneOTPErrorState(this.errorMsg);
}

// get profile
class GetProfileLoadingState extends AuthState {}

class GetProfileSuccessState extends AuthState {
  final ProfileEntity userModel;

  GetProfileSuccessState(this.userModel);
}

class GetProfileFailureState extends AuthState {
  final String errMessage;

  GetProfileFailureState({required this.errMessage});
}

// update Profile
class UpdateProfileLoadingState extends AuthState {}

class UpdateProfileSuccessState extends AuthState {
  final ProfileEntity userModel;

  UpdateProfileSuccessState(this.userModel);
}

class UpdateProfileFailureState extends AuthState {
  final String errMessage;

  UpdateProfileFailureState({required this.errMessage});
}
