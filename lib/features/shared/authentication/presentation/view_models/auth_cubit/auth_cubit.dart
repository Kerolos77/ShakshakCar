import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/login_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/login_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/signup_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/get_profile_usecase.dart';
import 'package:shakshak/features/shared/authentication/domain/usecases/update_profile_usecase.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/authentication/data/models/login_body.dart';
import 'package:shakshak/features/shared/authentication/data/models/signup_body.dart';
import 'package:shakshak/core/services/notification_service.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/core/services/user_storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.verifyPhoneOtpUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(AuthInitial());

  final TextEditingController phoneController = TextEditingController();
  String roleSelection = '';
  String completeNumber = '';
  String countryCode = '';

  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  void selectRoleType(String method) {
    roleSelection = method;
    CacheHelper.saveData(key: AppConstant.kRoleSelection, value: method);
    // debugPrint(roleSelection);
    emit(RoleSelectionChangedState());
  }

  void changeCompleteNumber(
      {required String completeNumber, required String countryCode}) {
    this.completeNumber = completeNumber;
    this.countryCode = countryCode;
    emit(LoginChangeCompleteNumberStatus());
  }

  void login({required LoginBody loginBody}) async {
    emit(LoginLoadingState());
    final result = await loginUseCase.call(LoginParams(phone: loginBody.phone));
    result.fold(
      (fail) => emit(LoginErrorState(fail.message)),
      (loginModel) {
        if (loginModel.data != null) {
          sl<RealtimeManager>().connect(url: ApiConstant.realTimeBaseUrl);
        }
        emit(LoginSuccessState(loginModel));
      },
    );
  }

  void signup({required SignupBody signupBody}) async {
    emit(RegisterLoadingState());
    final result = await signupUseCase.call(SignupParams(
      userName: signupBody.userName,
      email: signupBody.email,
      phoneNumber: signupBody.phoneNumber,
      countryCode: signupBody.countryCode,
      referralCode: signupBody.referralCode,
      gender: signupBody.gender,
    ));
    result.fold(
      (fail) => emit(RegisterErrorState(fail.message)),
      (profileModel) {
        this.profileModel = profileModel;
        if (profileModel.data != null) {
          _saveSessionAndConnectRealtime(profileModel.data!);
        }
        emit(RegisterSuccessState(profileModel));
      },
    );
  }

  void verifyPhoneOtp({
    required int otpCode,
  }) async {
    emit(VerifyPhoneOTPLoadingState());
    var result = await verifyPhoneOtpUseCase
        .call(VerifyPhoneOtpParams(otp: otpCode.toString()));
    result.fold((fail) {
      debugPrint("error while verify phone otp ${fail.message}");
      emit(VerifyPhoneOTPErrorState(fail.message));
    }, (profileModel) {
      this.profileModel = profileModel;
      if (profileModel.data != null) {
        _saveSessionAndConnectRealtime(profileModel.data!);
      }
      emit(VerifyPhoneOTPSuccessState(profileModel));
    });
  }

  void logout() async {
    sl<RealtimeManager>().disconnect();
    CacheHelper.removeData(key: AppConstant.kToken);
    CacheHelper.removeData(key: AppConstant.kIsDriver);
    CacheHelper.removeData(key: AppConstant.kUserIdOtp);
    CacheHelper.removeData(key: 'saved_places');
    CacheHelper.removeData(key: 'last_source_place');
    CacheHelper.removeData(key: 'last_destination_place');
    await UserStorageService.removeUser();
  }

  ProfileEntity? profileModel;

  void getProfile() async {
    emit(GetProfileLoadingState());
    var result = await getProfileUseCase.call(const NoParameters());
    result.fold((error) {
      debugPrint("error while get profile data${error.message}");
      return emit(GetProfileFailureState(errMessage: error.message));
    }, (success) {
      profileModel = success;
      return emit(GetProfileSuccessState(success));
    });
  }

  void updateProfile({
    required String name,
    required String email,
    required int countryId,
    required int cityId,
    File? photo,
  }) async {
    emit(UpdateProfileLoadingState());
    var result = await updateProfileUseCase.call(UpdateProfileParams(
      name: name,
      email: email,
      countryId: countryId,
      cityId: cityId,
      photo: photo,
    ));
    result.fold((fail) {
      debugPrint("error while update profile ${fail.message}");
      emit(UpdateProfileFailureState(errMessage: fail.message));
    }, (profileModel) {
      this.profileModel = profileModel;
      emit(UpdateProfileSuccessState(profileModel));
    });
  }

  void _saveSessionAndConnectRealtime(UserDataEntity data) {
    if (data.id != null) {
      CacheHelper.saveData(key: AppConstant.kUserIdOtp, value: data.id);
    }
    if (data.token != null) {
      CacheHelper.saveData(key: AppConstant.kToken, value: data.token);
    }
    if (data.name != null) {
      CacheHelper.saveData(key: AppConstant.kUserName, value: data.name);
    }
    if (data.isDriver != null) {
      CacheHelper.saveData(key: AppConstant.kIsDriver, value: data.isDriver);
    }
    sl<RealtimeManager>().connect(url: ApiConstant.realTimeBaseUrl);

    _initNotificationAndFcmToken();
  }

  void _initNotificationAndFcmToken() async {
    final user = UserStorageService.getUser();
    if (user != null) {
      if (sl.isRegistered<NotificationCubit>()) {
        sl<NotificationCubit>().init(user);
      }
    }
    
    try {
      String? token = await sl<NotificationService>().getToken();
      if (token != null) {
        if (sl.isRegistered<NotificationCubit>()) {
          sl<NotificationCubit>().updateFcmToken(token);
        }
      }
    } catch (e) {
      debugPrint("Failed to update FCM token after login: $e");
    }
  }
}
