import 'package:shakshak/features/shared/payment/domain/entities/card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

// Get Cards
class GetSavedCardsLoading extends PaymentState {}

class GetSavedCardsSuccess extends PaymentState {
  final List<SavedCardEntity> cards;
  GetSavedCardsSuccess(this.cards);
}

class GetSavedCardsFailure extends PaymentState {
  final String errorMessage;
  GetSavedCardsFailure(this.errorMessage);
}

// Add Card
class AddCardLoading extends PaymentState {}

class AddCardSuccess extends PaymentState {
  final CardEntity card;
  AddCardSuccess(this.card);
}

class AddCardRequiresWebView extends PaymentState {
  final String checkoutUrl;
  final String orderId;

  AddCardRequiresWebView(this.checkoutUrl, this.orderId);
}

class AddCardFailure extends PaymentState {
  final String errorMessage;
  AddCardFailure(this.errorMessage);
}

// Delete Card
class DeleteCardLoading extends PaymentState {}

class DeleteCardSuccess extends PaymentState {}

class DeleteCardFailure extends PaymentState {
  final String errorMessage;
  DeleteCardFailure(this.errorMessage);
}

// Wallet Operations
class PayWithSavedCardWalletLoading extends PaymentState {}

class PayWithSavedCardWalletSuccess extends PaymentState {}

class PayWithSavedCardWalletFailure extends PaymentState {
  final String errorMessage;
  PayWithSavedCardWalletFailure(this.errorMessage);
}

class ChargeWalletNewCardLoading extends PaymentState {}

class ChargeWalletNewCardSuccess extends PaymentState {
  final String checkoutUrl;
  ChargeWalletNewCardSuccess(this.checkoutUrl);
}

class ChargeWalletNewCardFailure extends PaymentState {
  final String errorMessage;
  ChargeWalletNewCardFailure(this.errorMessage);
}
