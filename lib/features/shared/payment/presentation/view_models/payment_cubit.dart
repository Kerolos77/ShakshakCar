import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/saved_cards_usecases.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/get_add_card_intent_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/delete_card_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/pay_with_saved_card_wallet_usecase.dart';
import 'package:shakshak/features/shared/payment/domain/usecases/charge_wallet_new_card_usecase.dart';
import 'payment_states.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final FetchSavedCardsUseCase fetchSavedCardsUseCase;
  final GetAddCardIntentUseCase getAddCardIntentUseCase;
  final DeleteCardUseCase deleteCardUseCase;
  final PayWithSavedCardWalletUseCase payWithSavedCardWalletUseCase;
  final ChargeWalletNewCardUseCase chargeWalletNewCardUseCase;

  PaymentCubit(
    this.fetchSavedCardsUseCase,
    this.getAddCardIntentUseCase,
    this.deleteCardUseCase,
    this.payWithSavedCardWalletUseCase,
    this.chargeWalletNewCardUseCase,
  ) : super(PaymentInitial());

  static PaymentCubit get(context) => BlocProvider.of(context);

  List<SavedCardEntity> savedCards = [];

  Future<void> getSavedCards() async {
    emit(GetSavedCardsLoading());
    final result = await fetchSavedCardsUseCase(const NoParameters());
    result.fold(
      (error) => emit(GetSavedCardsFailure(error.message)),
      (cards) {
        savedCards = cards;
        emit(GetSavedCardsSuccess(savedCards));
      },
    );
  }

  Future<void> addCardIntent() async {
    emit(AddCardLoading());
    final result = await getAddCardIntentUseCase(const NoParameters());
    result.fold(
      (error) => emit(AddCardFailure(error.message)),
      (intent) {
        emit(AddCardRequiresWebView(intent.checkoutUrl, intent.orderId));
      },
    );
  }

  Future<void> deleteCard(String cardId) async {
    emit(DeleteCardLoading());
    final result = await deleteCardUseCase(cardId);
    result.fold(
      (error) => emit(DeleteCardFailure(error.message)),
      (_) {
        savedCards.removeWhere((element) => element.id.toString() == cardId);
        emit(DeleteCardSuccess());
        emit(GetSavedCardsSuccess(savedCards));
      },
    );
  }

  Future<void> payWithSavedCardForWallet(int cardId, double amount) async {
    emit(PayWithSavedCardWalletLoading());
    final result = await payWithSavedCardWalletUseCase(
        PayWithSavedCardWalletParams(savedCardId: cardId, amount: amount));
    result.fold(
      (error) => emit(PayWithSavedCardWalletFailure(error.message)),
      (_) => emit(PayWithSavedCardWalletSuccess()),
    );
  }

  Future<void> chargeWalletWithNewCard(double amount) async {
    emit(ChargeWalletNewCardLoading());
    final result = await chargeWalletNewCardUseCase(
        ChargeWalletNewCardParams(amount: amount));
    result.fold(
      (error) => emit(ChargeWalletNewCardFailure(error.message)),
      (intent) => emit(ChargeWalletNewCardSuccess(intent.checkoutUrl)),
    );
  }
}
