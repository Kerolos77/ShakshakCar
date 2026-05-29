import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/saved_cards_usecases.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/saved_cards/saved_cards_state.dart';

class SavedCardsCubit extends Cubit<SavedCardsState> {
  final FetchSavedCardsUseCase fetchSavedCardsUseCase;
  final PayWithSavedCardUseCase payWithSavedCardUseCase;

  SavedCardsCubit({
    required this.fetchSavedCardsUseCase,
    required this.payWithSavedCardUseCase,
  }) : super(SavedCardsInitial());

  static SavedCardsCubit get(context) => BlocProvider.of(context);

  Future<void> fetchSavedCards() async {
    emit(SavedCardsLoading());
    final result = await fetchSavedCardsUseCase(NoParameters());
    result.fold(
      (failure) => emit(SavedCardsError(failure.message)),
      (cards) => emit(SavedCardsLoaded(cards)),
    );
  }

  Future<void> payWithCard({
    required int savedCardId,
    required double amount,
    required int orderId,
  }) async {
    emit(PayWithSavedCardLoading());
    final result = await payWithSavedCardUseCase(
      PayWithSavedCardParams(
        savedCardId: savedCardId,
        amount: amount,
        orderId: orderId,
      ),
    );
    result.fold(
      (failure) => emit(PayWithSavedCardError(failure.message)),
      (_) => emit(PayWithSavedCardSuccess()),
    );
  }
}
