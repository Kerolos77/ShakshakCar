part of 'theme_cubit.dart';

abstract class ThemeState {
  final AppThemeMode themeMode;
  const ThemeState({required this.themeMode});
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({required AppThemeMode themeMode}) : super(themeMode: themeMode);
}

class ThemeChanged extends ThemeState {
  const ThemeChanged({required AppThemeMode themeMode}) : super(themeMode: themeMode);
} 