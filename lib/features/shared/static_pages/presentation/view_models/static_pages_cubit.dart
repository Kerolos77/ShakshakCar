import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shakshak/features/shared/static_pages/domain/entities/static_pages_entity.dart';
import 'package:shakshak/features/shared/static_pages/domain/usecases/get_static_pages_usecase.dart';

part 'static_pages_state.dart';

class StaticPagesCubit extends Cubit<StaticPagesState> {
  StaticPagesCubit(this.getStaticPagesUseCase) : super(StaticPagesInitial());

  final GetStaticPagesUseCase getStaticPagesUseCase;

  Future<void> getStaticPages({required int id}) async {
    emit(StaticPagesLoading());
    var result = await getStaticPagesUseCase(id);
    result.fold((error) {
      debugPrint("error while get StaticPages data ${error.message}");
      return emit(StaticPagesFailure(errorMessage: error.message));
    }, (success) {
      return emit(StaticPagesSuccess(staticPagesModel: success));
    });
  }
}
