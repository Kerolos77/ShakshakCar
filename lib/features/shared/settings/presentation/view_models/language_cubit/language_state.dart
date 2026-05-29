part of 'language_cubit.dart';

@immutable
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageChooseLangState extends LanguageState {}

class LanguageChangeLangState extends LanguageState {}
