import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/resources/app_colors.dart';

part 'theme_state.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeInitial(
          themeMode: _getInitialThemeMode(),
        ));

  static AppThemeMode _getInitialThemeMode() {
    final saved = CacheHelper.getData(key: AppConstant.kThemeMode);
    if (saved == 'dark') return AppThemeMode.dark;
    return AppThemeMode.light;
  }

  void changeTheme(AppThemeMode mode) {
    emit(ThemeChanged(themeMode: mode));
    CacheHelper.saveData(
        key: AppConstant.kThemeMode, value: mode == AppThemeMode.dark ? 'dark' : 'light');
  }

  ThemeData get themeData =>
      state.themeMode == AppThemeMode.dark ? AppColors.darkTheme : AppColors.lightTheme;
} 

