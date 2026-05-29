import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';
import 'package:shakshak/features/shared/faq/domain/usecases/get_faqs_usecase.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';

part 'faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  FaqsCubit(this.getFaqsUseCase) : super(FaqsInitial());

  final GetFaqsUseCase getFaqsUseCase;

  Future<void> getFaqs() async {
    emit(FaqsLoading());
    var result = await getFaqsUseCase(const NoParameters());
    result.fold((error) {
      debugPrint("error while get Faqs data ${error.message}");
      return emit(FaqsFailure(errorMessage: error.message));
    }, (success) {
      return emit(FaqsSuccess(faqsEntity: success));
    });
  }
}
