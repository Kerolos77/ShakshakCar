import 'package:flutter/material.dart';

import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';

@immutable
sealed class SavedCardsState {}

final class SavedCardsInitial extends SavedCardsState {}

final class SavedCardsLoading extends SavedCardsState {}

final class SavedCardsLoaded extends SavedCardsState {
  final List<SavedCardEntity> cards;
  SavedCardsLoaded(this.cards);
}

final class SavedCardsError extends SavedCardsState {
  final String message;
  SavedCardsError(this.message);
}

final class PayWithSavedCardLoading extends SavedCardsState {}

final class PayWithSavedCardSuccess extends SavedCardsState {}

final class PayWithSavedCardError extends SavedCardsState {
  final String message;
  PayWithSavedCardError(this.message);
}
