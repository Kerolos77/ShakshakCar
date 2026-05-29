import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:shakshak/core/constants/app_const.dart';

part 'language_state.dart';

enum LanguagesEnum { arabic, english }

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());
  bool arabicLang = AppConstant.currentLanguage == 'ar' ? true : false;
  void chooseLanguage(LanguagesEnum langEnum) {
    if (langEnum == LanguagesEnum.arabic) {
      arabicLang = true;
    } else if (langEnum == LanguagesEnum.english) {
      arabicLang = false;
    }
    emit(LanguageChooseLangState());
  }

  void changeLanguage({required String languageCode}) {
    AppConstant.currentLanguage = languageCode;
    emit(LanguageChangeLangState());
  }
}


